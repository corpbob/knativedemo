---
layout: post
title: "Computing the value of PI using Ansible"
author: "Bobby Corpus"
categories: journal
tags: [documentation,sample]
image: Compute_Pi_Using_Ansible/computing_pi.png-cards.png
---

I recently conducted a customized ansible training to some awesome engineers. As part of our fun with Ansible, we created an ansible script to compute the value of $$\pi$$. We did this by using the following formula:

$$
\pi = 4\int_0^1 \frac{1}{1+x^2} dx 
$$

The idea is to subdivide the interval $$[0,1]$$ into $$N$$ rectangles. The width of this rectangle multiplied by its height given by $$1/(1+x^2)$$ will give the area of the rectangle. Summing all the rectangles will give the value $$\pi/4$$.  


![/assets/img/Compute_Pi_Using_Ansible/sum_rectangles.png](/assets/img/Compute_Pi_Using_Ansible/sum_rectangles.png)

If the number of nodes is given by ```size```, then the interval $$[0,1]$$ will be divided into ```size``` intervals. Each node is assigned an interval between $$[0,1]$$. 

![/assets/img/Compute_Pi_Using_Ansible/pi_subdivision.png](/assets/img/Compute_Pi_Using_Ansible/pi_subdivision.png)

Ansible has an array variable called ```play_hosts``` that keeps track of the nodes that participate in the playbook run. The position of the node in this array will allow the node to determine which interval it will sum rectangles. So if a node's position is given by ```position```, then that node will sum rectangles from

$$
x=\displaystyle \frac{1}{\mathrm{size}}\cdot \mathrm{position}
$$

up to


$$
x=\displaystyle \frac{1}{\mathrm{size}}\cdot \mathrm{position} + \frac{N}{\mathrm{size}}\cdot \mathrm{width}
$$


The secret ingredient here is to be able to get the results of each node's computation and allow the bastion host to sum the partial results. To do this, we define a variable called ```pi_var``` that uses jinja2 templates. The code below achieves by appending each node's value of ```slice_of_pi``` to the variable ```o```.

<pre>
  <code>
  {% raw %}
    pi_var: |
      {%- set o=[] %}
      {%- for i in play_hosts %}
        {%- if o.append(hostvars[i].slice_of_pi) %}
        {%- endif %} 
      {%- endfor %}
      {{ o }}
  {% endraw %}
  </code>
</pre>


Each node will then compute $$\pi$$ according to the interval it will operate on:

<pre>
  <code>
  {% raw %}
      echo ""|awk '{
                     pi=0;
                     size= {{ play_hosts|length }};
                     N=int({{ num_intervals }}/size)*size;
                     width=1/N;
                     x=1/size*{{ position }}; 
                     for(i=0;i<N/size;i++){
                       x=x+width; 
                       pi=pi+1/(1+x*x)
                     };
                     print 4*pi/N
                   }'
   {% endraw %}
  </code>
</pre>

Finally, here is the ansible playbook:

<pre>
  <code>
{% raw %}
---
- hosts: all
  vars:
    num_intervals: 1000
    pi_var: |
      {%- set o=[] %}
      {%- for i in play_hosts %}
        {%- if o.append(hostvars[i].slice_of_pi) %}
        {%- endif %} 
      {%- endfor %}
      {{ o }}
  gather_facts: no
  tasks:
  - set_fact:
      position: "{{ play_hosts.index(inventory_hostname) }}"

  - name: Each node computes partial value according to the range assigned to it
    shell: |
      echo ""|awk '{
                     pi=0;
                     size= {{ play_hosts|length }};
                     N=int({{ num_intervals }}/size)*size;
                     width=1/N;
                     x=1/size*{{ position }}; 
                     for(i=0;i<N/size;i++){
                       x=x+width; 
                       pi=pi+1/(1+x*x)
                     };
                     print 4*pi/N
                   }'
    register: pi_reg

  - set_fact:
      slice_of_pi: "{{ pi_reg.stdout }}"

  - name: Print partial sums from all nodes
    debug: 
      var: pi_var
    run_once: true
    delegate_to: 127.0.0.1

  - name: Sum to get the value of Pi 
    set_fact:
      pi: '{{ pi_var|map("float")|sum }}'

  - name: Print value of Pi 
    debug: 
      var: pi
    run_once: true
    delegate_to: 127.0.0.1
{% endraw %}
  </code>
</pre>

## Understanding the computation

To see this, we know that if $$\tan(\theta) = x$$, then 

$$
\begin{array}{rl}
\displaystyle \frac{\sin(\theta)}{\cos\theta} &= x
\end{array}
$$

Differentiating both sides, we get

$$
\begin{array}{rl}
\displaystyle \frac{\cos\theta \cdot d(\sin\theta) - sin\theta \cdot d(\cos\theta)}{\cos^2\theta} &= dx\\
\displaystyle \frac{\cos^2\theta + \sin^2\theta}{\cos^2\theta} \cdot d\theta &= dx\\
\displaystyle \frac{1}{\cos^2\theta}d\theta &= dx\\
d\theta &= cos\theta dx
\end{array}
$$ 

Since $$\tan\theta = x$$, we can imagine a right triangle with the following sides:

![/assets/img/Compute_Pi_Using_Ansible/tangent_triangle.png](/assets/img/Compute_Pi_Using_Ansible/tangent_triangle.png)

Using this triangle, 

$$
\displaystyle \cos^2 \theta = \frac{1}{1+x^2}
$$

Therefore,

$$
\begin{array}{rl}
d\theta &= \displaystyle \frac{1}{1+x^2}\\
\theta &= \displaystyle \int \frac{1}{1+x^2} \\
tan^{-1}{x} &= \displaystyle \int \frac{1}{1+x^2}
\end{array}
$$

Integrating $$x$$ between 0 and 1 we get:

$$
\int_0^1 \frac{1}{1+x^2} = \tan^{-1} 1 - \tan^{-1} 0 = \pi/4
$$ 

and the result follows.




---
layout: post
title: "Thoughts on Performance Tuning"
author: "Bobby Corpus"
categories: journal
tags: [documentation,sample]
#image: le-cards.png
---

Tuning an application for performance is like finding a needle in a haystack. If someone asks you "Is my web server parameters correct?" "Is my connection pool settings correct?", "How do I even know my application needs to be tuned or shall I put more resources?" The correct answer is "I don't know". An application does not exist in isolation. Unless your application is a static website, chances are it needs a database to read and write to and probably has a proxy server in front of it. With so many parameters to tune, where do you begin?  Blindly doing performance tuning is a waste of time. 

So why do we tune the a system? The most obvious answer is economics. If resources cost nothing, then we can put a lot of them into our application. Then we don't need to tune the system. However, resources are limited and more often than not, they are expensive. When we see that our application is slow but our application is not even maximizing the resources allocated to it, then that's when we decide to tune it.  Tuning is also a time consuming task so we need to establish a goal which we think is is good enough. When we reach that goal, then we can stop our tuning exercise.

Performance tuning is like optimizing road traffic. You need to determine first where the bottleneck because that's the source of the problem. If you tune everything elase except the bottleneck, then your efforts will not yeild anything and your system will still be slow. When you are able to remove the bottleneck, you will then  ask the question "Did I achieve my performance goal?", If yes, then you can stop your tuning exercise. Otherwise, you go find the next bottleneck.

## Some Methodology

There's a lot of trial and error in performance tuning. It becomes much worse when our general approach is also trial and error. It's like throwing a dart in the dark and hoping it will land on the dartboard. I would like to approach performance tuning in this manner:

1. Create a system diagram
2. Do a load test
3. Determine the bottleneck.
4. Tune the bottleneck
5. Repeat Step 2 until there is no more performance improvement
6. Scale horizontally by adding more nodes
7. Update system diagram
8. Repeat Step 2 until there is no more performance improvement

A system diagram is like a map your territory. It does not need to be fancy and not too detailed. You need to be able to identify the components and take note of the performance characteristics of those components. The diagram allows you to look at the overall picture. Here is an example of a system diagram.

![/assets/img/blog_system_diagram-cards.png](/assets/img/blog_system_diagram-cards.png)

The network is also a system component which I left out in the diagram. The reason for doing so is that I assume the network is not a bottleneck here. When the network becomes the bottleneck, it makes sense to put it here.

Before we do anything else, let's record the baseline of our system. Record how the CPU utilization ,RAM and Disk IO of your system when it's not being used. Do this for all components in your diagram. 

I find that focusing on increasing the transaction given the CPU utilization of the system is a good start. It will allow you do uncover bottlenecks that will prevent you from reaching 100% utilization.

Next you can do performance testing on your application. Let's assume that we are testing a RESTful API. We can use the Apache Benchmark tool to do our performance test.

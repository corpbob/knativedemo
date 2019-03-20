---
layout: post
title: "How to run a docker image in OpenShift"
author: "Bobby Corpus"
categories: journal
tags: [documentation,sample]
#image: cards.jpg
---

## Login into OpenShift 

```
oc login -u openshift-devel
```

## Create a new project

```
oc new-project myproject
```

## Run the app 

```
oc new-app bcorpusjr/tomcat
```



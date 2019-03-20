---
layout: post
title: "OpenShift Workshop"
author: "Bobby Corpus"
categories: journal
tags: [documentation,sample]
#image: cards.jpg
---

## Contents
- [How to run a docker image in OpenShift](openshift_workshop/01_run_a_docker_image.html)
You'll learn how to run a Docker image inside OpenShift to take advantage of Self-Healing, High Availability, and Auto-scaling.
- [Adding a Database Using Templates](openshift_workshop/02_01_adding_a_database_using_templates.html)
Will introduce you to the concept of templates. In particular, you will be adding a database using a template. This database will be used by [Gogs](https://gogs.io/) Git Service.
- [Running your own Git Service](openshift_workshop/03_running_your_own_git_service.html)
We will be installing our individual git service that will be used in CI/CD.
- [Using ConfigMaps](openshift_workshop/04_using_config_maps.html)
Configuration is the difference between environments and should not be baked into the container image but rather externalized. This exercise will introduce you to externalizing configuration using environment variables and ConfigMaps.
- [Using Jenkins Pipeline](openshift_workshop/05_using_jenkins_pipeline.html)
Continuous Integration/Continuous Deployment and Containerization enables rapid deployment from Development to Production with minimal risk and rapid-rollback. We will use the built-in Jenkins pipeline of OpenShift to trigger the build of our application.
- [Configure the CI/CD pipeline](openshift_workshop/06_configure_cicd.html)
We will configure an end-to-end pipeline starting from a code pushed to the Git until it deploys to a higher environment with approvals in between. This demonstrates the ease at which containerization has make deployments rapid and can be done in business hours.



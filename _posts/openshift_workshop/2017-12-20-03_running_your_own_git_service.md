---
layout: post
title: "Running your own Git Service"
author: "Bobby Corpus"
categories: journal/openshift_workshop
tags: [documentation,sample]
#image: cards.jpg
---

## Run the Go Git Service image using the command below

```
oc new-app wkulhanek/gogs:11.4
```

## Attach storage to gogs and mount to /data

We are going to replace the "non-persistent" volume mounted on /data and change it to a persistent volume. Go to Applications->Deployments->gogs->Configuration. Scroll down to volumes and delete the volume mounted on /data.

![Delete Gogs Non-Persistent Volume](/assets/img/openshift_workshop/delete_gogs_volume.png)

Click on Add Storage. 

![Add New Storage](/assets/img/openshift_workshop/add_gogs_storage1.png)

You'll notice there is only one storage and it's already claimed by another container. We need to create another storage. Click on 'create storage' and input the following details as show below:

![Gogs Storage Details](/assets/img/openshift_workshop/gogs_storage_details.png)

Mount gogs-storage to /data and click Add

![Create New Storage](/assets/img/openshift_workshop/add_gogs_storage2.png)

# Expose the gogs service 

Type the following command to create a route for the gogs service.

```
oc expose svc gogs
```

## Configure the gogs database by accessing the gogs url. TODO: Add detailed steps.
Click on the gogs url to open the gogs service.

![Gogs Install Page](/assets/img/openshift_workshop/gogs_install_page.png)

Set the following parameters to the following values:
- Database Type = Postgresql
- Host = postgresql:5432
- User = gogs
- Password = gogs
- Database Name = gogs
- Run User = gogs

Set the application url to the url of gogs.

Click on Install Gogs. You will get the following page

![Gogs Sign-In Page](/assets/img/openshift_workshop/gogs_sign_in_page.png)

In the next exercise, we will learn how to externalize configuration using ConfigMaps

Next Exercise: [Using ConfigMaps](04_using_config_maps.md)

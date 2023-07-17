Running Posit Applications in Docker
=============================

## Overview and Purpose of this Document

Posit applications are intended to be installed on stand-alone servers running a Linux OS.  The applications run as services on the server and configuration of their runtime settings are done via edits of config files at the Linux filesystem level.  Users of the applications interact with them via Web front-ends provided by the server on specified ports (when running HTTP), or via a single secure port (typically 443 when using HTTPS).

Given how these applications run, it is relatively simple to implement them as containerized services inside of Docker and, in fact, several Posit installation configurations (such as Kubernetes integration) explicitly require the use of containers.  In that case, Helm charts determine the configuration of the deployed applications inside of Kubernetes.  However, it is also possible to deploy Posit applications as standalone containers running on a VM or other Linux host without the use of Helm charts.  When run in this fashion, a common starting point is to use the images which are available at  the [Docker Hub rstudio page](https://hub.docker.com/u/rstudio).

When using the images available on Docker Hub as a starting point, there is information on each application's homepage that explains how to spin up the application in a basic fashion.

- https://hub.docker.com/r/rstudio/rstudio-connect
- https://hub.docker.com/r/rstudio/rstudio-workbench
- https://hub.docker.com/r/rstudio/rstudio-package-manager

The intent of this document is to add some detail around how each image  can be customized to enhance or change their basic configuration.  These changes are focused on capturing basic tasks that a system administrator deploying these containers might wish to implement for the users that will ultimately be interacting with the application.


## Basic Docker Image Customization Concepts

There are different ways in which a Posit application running inside a Docker image can be updated or modified.  Several of these are discussed on the Docker Hub pages, but some additional context will be provided below.  Three of the most commonly used approaches are shown below.

### 1. Custom runtime parameters supplied when the image is started, or "run".
In the example below, the `-p`, `-v` and `-e` flags all provide optional runtime parameters that affect the operation of the `rstudio-connect` image.
```
docker run -it --privileged \
    -p 3939:3939 \
    -v $PWD/data/rsc:/data \
    -e RSC_LICENSE=$RSC_LICENSE \
    rstudio/rstudio-connect:ubuntu1804
```

### 2. The injection of custom config files into the image at runtime
The Posit Docker images are provided with minimal config files that control the behavior of each application.  It is possible to replace those config files with modified ones that contain additional or modified values to enable additional functionality or make changes to the default behavior of the application.

In the example below, the `-v` command specifies that the `rstudio-connect.gcfg` in the current local working directory will be brought into the container and mounted in the place of the default `/etc/rstudio-connect/rstudio-connect.gcfg` that is shipped with the image.

```
docker run -it --privileged \
    -p 3939:3939 \
    -v $PWD/rstudio-connect.gcfg:/etc/rstudio-connect/rstudio-connect.gcfg \
    rstudio/rstudio-connect:ubuntu1804
```

### 3. Use of a Dockerfile to build a custom image that contains modifications which are "built-in" to the image.
In this Dockerfile example, the Ubuntu Advanced Package Tool (apt) is told to update it's knowledge of available system packages and then install the `gdebi` tool.  The `RUN` command indicates that the command immediately following it should be executed inside the image as part of its "build".

```
# Simple Dockerfile
FROM rstudio/rstudio-connect:bionic-2023.05.0

RUN apt-get update
RUN apt-get install -y gdebi
```
When this Dockerfile is used in a build, typically with a command like this...
```
$ docker build -t rstudio/connect-docker .
```
...the resulting `rstudio/connect-docker` image will contain the `gdebi` tool.  In effect, the build process has taken the starting `rstudio/rstudio-connect` image and modified it by adding the `gdebi` system tool. A new image named `rstudio/connect-docker` will be created and anytime that new image is used, the `gdebi` tool will already be present in it.

### So what's the "right" way to do this?

"It depends".  Sometimes it is beneficial to use a combination of all three methods, but there is no real _"right"_ way to do it.  Some methods might be more beneficial in certain circumstances than in others, but the instructions shown here should result in functional changes that will run.


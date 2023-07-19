# Posit Package Manager

## Overview
The files and instructions in this directory will create a containerized instance of Posit Package Manager with the following characteristics:
1. Package Manager version 2023.04.0-6
2. R versions 3.6.2 and 4.2.0
3. Host's `/data/rspm_data` dir mounted as `/data` in container
4. CRAN repo setup as "cran" on PM
5. PyPi repo setup as "pypi" on PM
6. Curated CRAN repo setup as "Restricted_CRAN" on PM
7. Gitbuilder R repo pulling from Github and setup as "git-hello-world on PM
8. Combined repo with Curated Cran and Gitbuilder sources as "NSW_Internal" on PM

## Prerequisites
* Host machine with the docker CLI setup
* Github access
* A valid Package Manager license file

## Setup Steps

### 1. Update the Dockerfile to point at your lic file
Replace "RSPM_2023-06-14.lic" in the Dockerfile entry below with the name of your file.
```
# Copy our license key into the container
COPY RSPM_2023-06-14.lic /etc/rstudio-pm/license.lic
```

### 2. Change the name of the host to match your machine
Edit the rstudio-pm.gcfg (included in this repo) and replace "posit2" in the line below with that name or IP of your host.
```
Address = http://posit2:4242
```

### 3. Build
Using the docker CLI, build from within the same directory as the Dockerfile.
```
$ docker build -t rstudio/package_manager-docker .
```

### 4. Test that the application runs
Run the application in interactive mode, so you can see any errors that might be generated.
```
$ docker run -it -p 4242:4242 rstudio/package_manager-docker:latest
```
You should be able to connect to `localhost:4242` and see Package Manager running there.

### 5. Set up a service configuration for Package Manager
To have Package Manager start up automatically and shut down cleanly when the machine is turned off, you'll want to setup a service definition.  There is an included file in this directory that can be used as a starting point, `package_manager-docker.service`.  

* Edit the file to reflect where on the host machine you want Package Manager to persist data.  In the block below:
```
ExecStart=/usr/bin/docker run --rm \
    --privileged \
    -v /data/rspm_data:/data \
    -p 4242:4242 \
    rstudio/package_manager-docker:latest
```
...replace the `/data/rspm_data` entry to whatever file path is appropriate on your host. (Note that you should leave the `:/data` there and only modify what is to the left of the colon.)

* Move the edited `package_manager-docker.service` file into place, which on my Ubuntu 20.04 machine is `/etc/systemd/system/`.

* Enable, and then start the service
```
$ sudo systemctl enable package_manager-docker.service
$ sudo systemctl start package_manager-docker.service
```

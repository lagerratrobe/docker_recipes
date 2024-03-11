## Discusses how to create a custom session image for Posit Workbench that implements GIS support.

Based off of this article, https://support.posit.co/hc/en-us/articles/360019253393-Using-Docker-images-with-RStudio-Workbench-RStudio-Server-Pro-Launcher-and-Kubernetes.  

* Assumes starting session image, rstudio/r-session-complete:jammy-2023.12.1.

In an nutshell, all this does is take the package additions from rocker-geospatial, https://github.com/rocker-org/geospatial, and adds them to a Workbench image so that it can run the same projects as rocker-geospatial, but on a Workbench server running in Kubernetes.

### Steps

Use the Dockerfile in this repo to build a new image and then push it up into whatever container registry you prefer.

```
$ docker build -t lagerratrobe/wb_session_images:rocker-gis-2023.12.1wb_v2 .
Successfully tagged lagerratrobe/wb_session_images:rocker-gis-2023.12.1wb_v2

$ docker push lagerratrobe/wb_session_images:rocker-gis-2023.12.1wb_v2
The push refers to repository [docker.io/lagerratrobe/wb_session_images]
```

Verify that new image is at https://hub.docker.com/repository/docker/lagerratrobe/wb_session_images/general.

Start an RStudio session on Workbench and point "Other" to: docker.io/lagerratrobe/wb_session_images:rocker-gis-2023.12.1wb_v2.  You should see:

> Pulling image "docker.io/lagerratrobe/wb_session_images:rocker-gis-2023.12.1wb_v2"

![wb_GIS_session_image](https://github.com/lagerratrobe/docker_recipes/assets/686797/708d089c-d515-47ab-907e-900561cb2071)

Should then be able to use packages like "sf" and "geosphere" in R.



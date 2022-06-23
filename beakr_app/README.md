## Small Docker image which exposes an R-based API using [beakr](https://github.com/MazamaScience/beakr) that returns map images.

### Steps to get going
  * build docker image directly from Github with:
    `docker build -t lagerratrobe/beakr_map https://github.com/lagerratrobe/docker_recipes.git#main:beakr_app`
  * Optionally, you can check out the code first and build in the dir
    ```
    $ git clone https://github.com/lagerratrobe/docker_recipes.git
    $ cd docker_recipes/beakr_app/
    $ docker build -t lagerratrobe/beakr_map .
    ```
  * You should now have a new docker image available
    ```
    $ docker images
    REPOSITORY               TAG       IMAGE ID       CREATED              SIZE
    lagerratrobe/beakr_map   latest    2996817660a4   About a minute ago   2.1GB
    rocker/tidyverse         latest    098ed2999cd6   7 hours ago          2.06GB
    ```
  * Start the container
    `$ docker run -d --name beakr_map -p 8080:8080 lagerratrobe/beakr_map`
  * Test that you get map images served up at `http://192.168.1.191:8080/usa?state=California`

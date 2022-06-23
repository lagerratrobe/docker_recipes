FROM rocker/tidyverse:latest

# set a directory for the app
WORKDIR /usr/src/app

# copy all the files to the container
COPY . .

# Install extra R packages
RUN install2.r --error \
    beakr \
    maps

# tell the port number the container should expose
EXPOSE 8080

# run the command
CMD ["Rscript", "./beakr_map.R"]

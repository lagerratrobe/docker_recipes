Installing RStudio Connect With Dropbox
---------------------------------------

Instructions for getting Connect running in a local Docker container that meets the  the following requirements:

- Picks up License key at runtime
- Has persistent storage for users and published work
- Respects options in Connect cfg file


### Basic Docker Hub Install

A good starting point are the [public facing docs](https://hub.docker.com/r/rstudio/rstudio-connect) on Docker Hub.  With these, you can get a local Docker instance of Connect running at http://localhost:3939.  As the page points out though, this lacks some functionality and is really just for testing.

__Toy Docker Connect Instance:__

```
$ docker pull rstudio/rstudio-connect

$ export RSC_LICENSE=XXX-XXX-XXX-XXX-XXX-XXX-XXX

$ docker run -it --privileged -p 3939:3939 -e RSC_LICENSE=$RSC_LICENSE rstudio/rstudio-connect:latest
```

However, it's actually quite easy to expand upon on that basic install to meet the requirements above.


### Create Dockerfile

Simple Dockerfile that pulls in the Docker Hub image and sets up a few things.

```
FROM rstudio/rstudio-connect

# 1. Copy our configuration over the default install configuration
COPY rstudio-connect.gcfg /etc/rstudio-connect/rstudio-connect.gcfg

# 2. Copy our license key into the container
COPY license.key /etc/rstudio-server/license.key

# 3. Activate the license
RUN /opt/rstudio-connect/bin/license-manager activate `cat /etc/rstudio-server/license.key`

# 4. Expose the configured listen port
EXPOSE 3939

# Launch Connect.
CMD ["--config", "/etc/rstudio-connect/rstudio-connect.gcfg"]
ENTRYPOINT ["/opt/rstudio-connect/bin/connect"]

```

Note: This relies on having a `license.key` file that contains a valid RStudio Connect key.

### Create Connect Config File

In addition to the Dockerfile, we need a `rstudio-connect.gcfg` file.  Below is a minimal one that works.

```
; /etc/rstudio-connect/rstudio-connect.gcfg

; RStudio Connect sample configuration
[Server]
SenderEmail = account@company.com
Address = http://0.0.0.0:3939

; The persistent data directory mounted into our container.
DataDir = /data

[Licensing]
LicenseType = local

; Use and configure local database.
[Database]
Provider = sqlite

[HTTP]
; RStudio Connect will listen on this network address for HTTP connections.
Listen = :3939

[Authentication]
; Specifies the type of user authentication.
Provider = password
```

### Tying it all together

When you build the image, you should see that your `rstudio-connect.gcfg` is being copied into the container  and that the license manager has activated your lic key.

```
$ docker build -t rstudio/connect-docker .
```
Should see the following:

```
Step 2/6 : COPY rstudio-connect.gcfg /etc/rstudio-connect/rstudio-connect.gcfg
<snip>

Step 4/6 : RUN /opt/rstudio-connect/bin/license-manager activate XXX-XXX-XXX-XXX-XXX-XXX-XXX
 ---> Running in 7cc4530bd04a
{"status":"activated","product-key":"XXX-XXX-XXX-XXX-XXX-XXX-XXX","has-key":true,"has-trial":true,"users":"20","user-activity-days":"365","shiny-users":"20","allow-apis":"1","expiration":1717891200000.0,"days-left":709,"license-engine":"4.4.3.0","license-scope":"system","result":0,"connection-problem":false}

<snip>
Successfully built 1920e66b0da3
Successfully tagged rstudio/connect-docker:latest
```

Then, you can run the image.

```
$ docker run -d --rm --privileged -p 3939:3939 -v /data/connect_data/:/data rstudio/connect-docker:latest
```

The `docker run` command is where you can specify what local directory you want Docker to mount as `/data` by using the `-v` flag.  In my case, I'm using `/data/connect_data`.

### Verify Container is running as desired

It's easy enough to see that the container is running.

```
$ docker container ls
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                                       NAMES
24a365d28559   rstudio/connect-docker:latest   "/opt/rstudio-connec…"   11 minutes ago   Up 11 minutes   0.0.0.0:3939->3939/tcp, :::3939->3939/tcp   reverent_cray
```

What is a bit more useful though, is to login to the container itself via the `exec` command and examine the Connect logs, etc.

```
$ docker exec -it 24a365d28559 bash

root@24a365d28559:/# tail -f /var/log/rstudio/rstudio-connect/rstudio-connect.log
<snip>
time="2022-07-06T19:54:05.988Z" level=info msg="Using file /var/log/rstudio/rstudio-connect/rstudio-connect.access.log to store Access Logs."
time="2022-07-06T19:54:05.988Z" level=info msg="Startup complete (~854.334713ms)"
time="2022-07-06T19:54:05.988Z" level=info msg="Starting HTTP server on :3939"
time="2022-07-06T19:54:05.987Z" level=info msg="Sweeping ad-hoc variants"
time="2022-07-06T19:54:35.287Z" level=info msg="Creating the initial worker;
```

### Shutdown the Container

```
$ docker stop 24a365d28559
24a365d28559
```

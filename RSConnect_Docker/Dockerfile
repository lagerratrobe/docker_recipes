FROM rstudio/rstudio-connect

# Copy our configuration over the default install configuration
COPY rstudio-connect.gcfg /etc/rstudio-connect/rstudio-connect.gcfg

# Copy our license key into the container
COPY license.key /etc/rstudio-server/license.key

# Activate the license 
RUN /opt/rstudio-connect/bin/license-manager activate `cat /etc/rstudio-server/license.key`

# Expose the configured listen port
EXPOSE 3939

# Launch Connect.
CMD ["--config", "/etc/rstudio-connect/rstudio-connect.gcfg"]
ENTRYPOINT ["/opt/rstudio-connect/bin/connect"]

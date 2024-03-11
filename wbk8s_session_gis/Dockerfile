FROM rstudio/r-session-complete:jammy-2023.12.1

# Install system deps for GDAL etc.
RUN apt update
RUN apt install -y  --no-install-recommends \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgsl0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    make \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev
 

# Install R 'sf', 'raster', etc. packages
RUN /opt/R/4.2.3/bin/R -e 'install.packages( c("RColorBrewer", "RandomFields", "RNetCDF", "BiocManager", "classInt", "deldir", "gstat", "hdf5r", "lidR", "mapdata", "maptools", "mapview", "ncdf4", "proj4 ", "raster", "rgdal", "rgeos", "rlas", "sf", "sp", "spacetime", "spatstat", "spdep", "geoR", "geosphere"), repos="https://packagemanager.rstudio.com/cran/__linux__/jammy/latest")'

# from bioconductor
RUN /opt/R/4.2.3/bin/R -e "BiocManager::install('rhdf5', site_repository='https://packagemanager.rstudio.com/bioconductor-3.19/latest', update=FALSE, ask=FALSE)"

FROM rstudio/rstudio-workbench

# 1. Copy the offline lic file into the image
COPY license.key /etc/rstudio/license.key

# 2. Activate the license
RUN /usr/lib/rstudio-server/bin/license-manager activate `cat /etc/rstudio/license.key`

# Update the timezone
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 3. Unscrew the TinyTeX install
RUN chmod -R 777 /opt/TinyTeX
RUN tlmgr option repository https://texlive.info/tlnet-archive/2022/04/18/tlnet/
RUN tlmgr install koma-script
RUN tlmgr install caption
RUN tlmgr install tcolorbox
RUN tlmgr install pgf
RUN tlmgr install environ
RUN tlmgr install oberdiek
RUN tlmgr install bookmark
RUN chmod 666 /opt/TinyTeX/tlpkg/texlive.tlpdb

# 4. Add an installed Python to System Path
RUN printf "PATH=/opt/python/3.8.10/bin:$PATH \n" >> /etc/profile.d/python.sh

# 5. Set RETICULATE_PYTHON
RUN printf "export RETICULATE_PYTHON=/opt/python/3.8.10/bin/python \n" >> /etc/rstudio/rsession-profile

# 6. Install the R Reticulate packge in at least one version of R
RUN /opt/R/4.1.0/bin/Rscript -e 'install.packages("reticulate", repos = "https://packagemanager.rstudio.com/cran/__linux__/bionic/latest")'

# 7. Set the default R version to the latest one we currently ship
RUN printf "rsession-which-r=/opt/R/4.1.0/bin/R \n" >> /etc/rstudio/rserver.conf

# 8. Set the CRAN binary repo 
RUN printf "CRAN=https://packagemanager.rstudio.com/cran/__linux__/bionic/latest \n" >> /etc/rstudio/repos.conf


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


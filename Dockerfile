
# Base image
FROM ubuntu:20.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# add CRAN PPA
RUN apt-get update && apt-get install -y apt-transport-https gnupg ca-certificates software-properties-common dirmngr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    r-base=4.1* 

# For building the report
RUN apt-get update && apt-get install -y \
    xsltproc \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion \
    libgit2-dev
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.3.2", repos="https://cran.rstudio.com/")'

# Tools used in the report

# Packages used in the report
RUN Rscript -e 'library(devtools); install_version("ggplot2", "3.3.3", repos="https://cran.rstudio.com/")'

# Package dependencies

# Using COPY will update (invalidate cache) if the tar ball has been modified!
COPY gggrid_0.1-0.tar.gz .
RUN R CMD INSTALL gggrid_0.1-0.tar.gz
# RUN Rscript -e 'devtools::install_github("pmur002/gggrid@v0.1-0")'

RUN apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV TERM dumb


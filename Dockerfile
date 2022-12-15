FROM openanalytics/r-ver:4.1.3

LABEL maintainer="Tom Clemens <tom.clemens@ed.ac.uk> and Mark Cherrie <mark.cherrie@iom-world.org>"

# system libraries of general use
RUN apt-get update && apt-get install --no-install-recommends -y \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -q -e "install.packages(c('shiny', 'rmarkdown'))"

#Mapper specific dependencies
RUN R -q -e "install.packages(c('leaflet', 'leaflet.extras', 'shinyjs', 'rgdal', 'shinyBS', 'gtools'))"
    
RUN R -q -e "install.packages(c('DT', 'BAMMtools', 'rgeos', 'tidyverse', 'mongolite', 'shinyWidgets', 'devtools'))"

RUN R -q -e "devtools::install_github('hrbrmstr/ipapi')"

# install dependencies of the euler app
RUN R -q -e "install.packages('Rmpfr')"

# copy the app to the image
RUN mkdir /root/alcoholtobacco
COPY alcoholtobacco /root/alcoholtobacco

COPY Rprofile.site /usr/local/lib/R/etc/

EXPOSE 3838

CMD ["R", "-q", "-e", "shiny::runApp('/root/alcoholtobacco')"]
FROM rocker/tidyverse

RUN mkdir /versoes_props
WORKDIR /versoes_props
COPY . .
RUN Rscript utils/installer.R

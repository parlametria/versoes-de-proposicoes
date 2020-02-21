FROM rocker/tidyverse

WORKDIR /versoes_props
RUN Rscript utils/installer.R
COPY . .

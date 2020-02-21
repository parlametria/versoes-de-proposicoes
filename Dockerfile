FROM rocker/tidyverse

WORKDIR /versoes_props
COPY utils ./utils
RUN Rscript utils/installer.R
COPY . .

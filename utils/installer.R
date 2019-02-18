#! /usr/bin/Rscript

#' @title Install and load a list of packages
#' @description Install new packages and load all required libraries
#' @param list_of_packages List of packages
install_and_load_packages <- function(list_of_packages) {
  
  print("Installing packages...")
  
  new_packages <- suppressMessages(suppressWarnings(
    list_of_packages[!(list_of_packages %in% installed.packages()[,"Package"])]))
  
  if(length(new_packages) > 0) {
    suppressMessages(suppressWarnings(install.packages(new_packages)))
  }
  
  suppressWarnings(suppressMessages(require("here", character.only = T)))
  suppressWarnings(suppressMessages(source(here::here("crawler/utils/constants.R"))))
  
  print("Installing latest version of congresso and agora-digital...")
  suppressWarnings(suppressMessages(devtools::install_github(.RCONGRESSO_URL, force = TRUE)))
  suppressWarnings(suppressMessages(devtools::install_github(.LEGGO_URL, force = TRUE)))
  
  print("Packages successfully installed.")
}

list_of_packages <- c("RCurl", "dplyr", "lubridate", "magrittr", "stats", 
                      "stringr", "tibble", "tidyr", "utils", "devtools", 
                      "optparse", "here")

install_and_load_packages(list_of_packages)
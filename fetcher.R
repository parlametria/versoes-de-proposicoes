#! /usr/bin/Rscript

#' @title Load packages
#' @description Load packages from list
load_packages <- function(list_of_packages) {
  print("Loading packages..")
  suppressWarnings(suppressMessages(lapply(list_of_packages, require, character.only=TRUE)))
}

#' @title Get arguments from command line option parsing
#' @description Get arguments from command line option parsing
get_args <- function() {
  args = commandArgs(trailingOnly=TRUE)
  
  option_list = list(
    optparse::make_option(c("-i", "--input"), 
                type="character", 
                default=.INPUT_FILEPATH,
                help=.HELP_INPUT_ARG, 
                metavar="character"),
    optparse::make_option(c("-o", "--output"), 
                type="character", 
                default=.OUTPUT_FILEPATH,
                help=.HELP_OUTPUT_ARG, 
                metavar="character")
  );
  
  opt_parser <- optparse::OptionParser(option_list = option_list) 
  opt <- optparse::parse_args(opt_parser)
  return(opt);
}

list_of_packages <- c("RCurl", "dplyr", "lubridate", "magrittr", "stats", 
                       "stringr", "tibble", "tidyr", "utils", "devtools", 
                      "optparse", "here", "rcongresso", "agoradigital")


suppressWarnings(suppressMessages(source(here::here("utils/constants.R"))))
message(.README_MESSAGE)
message(.HELP_MESSAGE)

load_packages(list_of_packages)

source(here::here("R/process_data.R"))

args <- get_args()

print("Fetching data...")
df <- fetch_data(args$input)

print("Saving results...")
save_data(df, args$output)

print("Successfully saved! :D")

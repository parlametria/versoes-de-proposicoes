#! /usr/bin/Rscript

#' @title Load packages
#' @description Load packages from list
load_packages <- function(list_of_packages) {
  print("Loading packages..")
  suppressWarnings(suppressMessages(sapply(list_of_packages, require, character.only=TRUE)))
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
    optparse::make_option(c("-e", "--emendas"), 
                          type="character", 
                          default=.INPUT_FILEPATH,
                          help=.HELP_INPUT_ARG, 
                          metavar="character"),
    optparse::make_option(c("-o", "--output"), 
                type="character", 
                default=.OUTPUT_FILEPATH,
                help=.HELP_OUTPUT_ARG, 
                metavar="character"),
    optparse::make_option(c("-a", "--avulsos_iniciais"), 
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
textos_proposicao_df <- fetch_textos_proposicao(args$input) 
emendas_df <- textos_proposicao_df %>% 
  filter(str_detect(tolower(tipo_texto), "emenda")) %>% 
  filter(tolower(tipo_texto) != "avulso de emendas")
textos_iniciais_materia_df <- textos_proposicao_df %>% 
  filter(str_detect(tolower(tipo_texto), "apresenta..o de proposi..o|avulso inicial da mat.ria"))

print("Saving results...")
emendas_raw <- readr::read_csv(args$emendas)
save_new_emendas(emendas_df, emendas_raw, args$output)

readr::write_csv(textos_iniciais_materia_df, args$avulsos_iniciais)


print("Successfully saved! :D")

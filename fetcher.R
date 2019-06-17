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
    optparse::make_option(c("-o", "--old_emendas"), 
                          type="character", 
                          default=.OLD_EMENDAS_FILEPATH,
                          help=.HELP_INPUT_ARG, 
                          metavar="character"),
    optparse::make_option(c("-e", "--emendas"), 
                          type="character", 
                          default=.EMENDAS_FILEPATH,
                          help=.HELP_INPUT_ARG, 
                          metavar="character"),
    optparse::make_option(c("-n", "--novas_emendas"), 
                          type="character", 
                          default=.NEW_EMENDAS_FILEPATH,
                          help=.HELP_OUTPUT_ARG, 
                          metavar="character"),
    optparse::make_option(c("-a", "--avulsos_iniciais"), 
                          type="character", 
                          default=.AVULSOS_FILEPATH,
                          help=.HELP_OUTPUT_ARG, 
                          metavar="character"),
    optparse::make_option(c("-t", "--textos"), 
                          type="character", 
                          default=.TEXTOS_FILEPATH,
                          help=.HELP_OUTPUT_ARG, 
                          metavar="character"),
    optparse::make_option(c("-f", "--flag"), 
                          type="integer", 
                          default=.FLAG,
                          help=.HELP_OUTPUT_ARG, 
                          metavar="integer")
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
print(args)

emendas_raw_new <- readr::read_csv(args$emendas,
                               col_types =   readr::cols(
                                 id_ext = readr::col_double(),
                                 codigo_emenda = readr::col_double(),
                                 data_apresentacao =readr:: col_date(format = ""),
                                 numero = readr::col_double(),
                                 local = readr::col_character(),
                                 autor = readr::col_character(),
                                 casa = readr::col_character(),
                                 tipo_documento = readr::col_character(),
                                 inteiro_teor = readr::col_character()
                               ))
if (args$flag == 1) {
  print("Fetching data...")
  emendas_raw_old <- 
    readr::read_csv(args$old_emendas,
                    col_types = readr::cols(
                      id_ext = readr::col_double(),
                      codigo_emenda = readr::col_double(),
                      data_apresentacao = readr::col_date(format = ""),
                      numero = readr::col_double(),
                      local = readr::col_character(),
                      autor = readr::col_character(),
                      casa = readr::col_character(),
                      tipo_documento = readr::col_character(),
                      inteiro_teor = readr::col_character()
                    )
    )
  new_emendas <- dplyr::anti_join(emendas_raw_new, emendas_raw_old, by = c("id_ext", "casa"))
  
  new_emendas_props <- new_emendas %>% dplyr::distinct(id_ext, casa)
  textos_proposicao_df <- fetch_textos_proposicao(new_emendas_props) 
  readr::write_csv(textos_proposicao_df, args$textos)
}else {
  textos_proposicao_df <- 
    readr::read_csv(args$textos,
                    col_types = readr::cols(
                      id_proposicao = readr::col_double(),
                      casa = readr::col_character(),
                      codigo_texto = readr::col_character(),
                      data = readr::col_datetime(format = ""),
                      tipo_texto = readr::col_character(),
                      descricao = readr::col_character(),
                      link_inteiro_teor = readr::col_character(),
                      pagina_inicial = readr::col_double(),
                      id_votacao = readr::col_logical()
                    ))
}

new_names <- c("id_proposicao", "codigo_texto", "data", "numero", "local", "autor", "casa", "tipo_texto", "link_inteiro_teor")
names(emendas_raw_new) <- new_names
emendas_raw_new <- textos_proposicao_df %>% 
  filter(str_detect(tolower(tipo_texto), "^e")) 
textos_iniciais_materia_df <- textos_proposicao_df %>% 
  filter(str_detect(tolower(tipo_texto), "apresenta..o de proposi..o|avulso inicial da mat.ria"))

print("Saving results...")
readr::write_csv(emendas_raw_new, args$novas_emendas)
readr::write_csv(textos_iniciais_materia_df, args$avulsos_iniciais)


print("Successfully saved! :D")

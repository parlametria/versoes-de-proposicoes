source(here::here("utils/constants.R"))

library(dplyr)

#' @title Fetch data for each proposition
#' @description Fetch data for each proposition in Senado and Camara
#' @param camara_id Proposition's ID from Camara
#' @param senado_id Proposition's ID from Senado
#' @examples 
#' fetch_propositions_versions(46249, 41703)
fetch_propositions_versions <- function(camara_id, senado_id) {
  
  print(paste0("Processando dados da proposição com id na câmara ", camara_id, " e no senado ", senado_id))
  
  if(!is.na(camara_id) & !is.na(senado_id)) {
    df <-
      agoradigital::extract_links_proposicao(id = camara_id, 
                                             casa = .CAMARA) %>%
      dplyr::bind_rows(agoradigital::extract_links_proposicao(id = senado_id,
                                                   casa = .SENADO))
    
  } else if (!is.na(camara_id)) {
    df <- agoradigital::extract_links_proposicao(id = camara_id, casa = .CAMARA)
    
  } else {
    df <- agoradigital::extract_links_proposicao(id = senado_id, casa = .SENADO)
  }
  
  return(df %>%
           dplyr::arrange(data) %>% 
           dplyr::filter(!is.na(tipo_texto)))
}

#' @title Fetch data for all propositions
#' @description Fetch data for all propositions in Senado and Camara
#' @param input_filepath Input filepath
#' @examples
#' fetch_data("data/proposicoes.csv")
fetch_data <- function(input_filepath) {
  propositions <- readr::read_csv(input_filepath, col_types = "iicc")
  df <- suppressMessages(suppressWarnings(
    purrr::map2_df(.x = propositions$id_camara,
                   .y = propositions$id_senado,
                   ~ fetch_propositions_versions(.x, .y))))
}

#' @title Save dataframe
#' @description Write dataframe in output_filepath
#' @param output_filepath Output filepath
save_data <- function(df, output_filepath) {
  df %>% 
    readr::write_csv(output_filepath)
}


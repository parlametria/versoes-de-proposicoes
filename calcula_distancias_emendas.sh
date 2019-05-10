#!/bin/bash

#Gera a tabela com os links para os arquivos dos textos e emendas
Rscript utils/installer.R

Rscript fetcher.R -i ../leggoR/data/tabela_geral_ids_casa.csv -o versoes_leggo.csv

#Entra na pasta data do leggo-content
cd ../leggo-content/util/data/

#Download dos arquivos em pdf
python3 download_csv_prop.py ../../../versoes-de-proposicoes/versoes_leggo.csv ../../../versoes-de-proposicoes/emendas/

#Converte de pdf para txt
./calibre_convert.sh ../../../versoes-de-proposicoes/emendas

#Verifica se os pdfs baixados eram imagens
python verifica_se_pdf_imagem.py ../../../versoes-de-proposicoes/emendas

#Calcula todas as distancias para todas as props
../../coherence/inter_emd_int/chama_inter_emd_int_para_todas_props.sh ../../../versoes-de-proposicoes/emendas/






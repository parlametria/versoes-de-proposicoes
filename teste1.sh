#!/bin/bash

#Rscript utils/installer.R

#Rscript fetcher.R -i ../leggoR/data/tabela_geral_ids_casa.csv -o versoes_leggo.csv

cd ../leggo-content/util/data/

#python3 download_csv_prop.py ../../../versoes-de-proposicoes/versoes_leggo.csv ../../../versoes-de-proposicoes/emendas/

./calibre_convert.sh ../../../versoes-de-proposicoes/emendas

python verifica_se_pdf_imagem.py ../../../versoes-de-proposicoes/emendas



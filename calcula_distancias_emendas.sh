#!/bin/bash

#Gera a tabela com os links para os arquivos dos textos e emendas
Rscript utils/installer.R

Rscript fetcher.R -i ../leggoR/data/tabela_geral_ids_casa.csv -e ../leggo-backend/data/emendas_raw.csv -o versoes_leggo.csv

mkdir emendas

#Entra na pasta data do leggo-content
cd ../leggo-content/util/data/

#Download dos arquivos em pdf
python3 download_csv_prop.py ../../../versoes-de-proposicoes/versoes_leggo.csv ../../../versoes-de-proposicoes/emendas/

#Converte de pdf para txt
./calibre_convert.sh ../../../versoes-de-proposicoes/emendas

#Verifica se os pdfs baixados eram imagens
python verifica_se_pdf_imagem.py ../../../versoes-de-proposicoes/emendas

#Separa Justificacoes
#Pasta com as emendas
DIR_DATA="../../../versoes-de-proposicoes/emendas"

for folder in $(ls $DIR_DATA/); do
        echo $DIR_DATA/$folder/txt
	python3 ../tools/SepararJustificacoes.py $DIR_DATA/$folder/txt ./justificacoes/
done

#Calcula todas as distancias para todas as props
../../coherence/inter_emd_int/chama_inter_emd_int_para_todas_props.sh justificacoes/

#Adicionar a coluna distancia a tabela de emendas do back
cd ../../../leggoR

Rscript scripts/update_emendas_dist.R  ../leggo-backend/data/emendas_raw.csv data/distancias/ ../leggo-backend/data/emendas.csv ../leggo-content/util/data/jus_all_dist/






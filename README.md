# Crawler Leggo-Content

Para baixar os dados com as versões do texto de uma proposição, deve-se seguir os passos abaixo.

 ## 1. Baixar o R
É necessário baixar o R para que os scripts sejam executados. [Aqui](https://www.digitalocean.com/community/tutorials/how-to-install-r-on-ubuntu-16-04-2) tem um tutorial para **instalar o R no Ubuntu 16.04**

## 2. Executar scripts

### 2.1. Instalador de pacotes

Este script instala todos os pacotes necessários para a execução do fetcher. Estando no diretório raiz do repositório, execute a seguinte linha de comando:

```
Rscript utils/installer.R
```

Ao fim da execução aparecerá uma mensagem indicando que a instação foi bem sucedida.

### 2.2. Fetcher

O fetcher é responsável pela obtenção das versões dos textos das proposições fornecidas por um csv, disponível em `data/proposicoes.csv`. Este arquivo contém as informações de proposições, como identificador na Câmara e no Senado, apelido e tema. Até o momento, estes dados são escritos manualmente, pois ainda não há um mapeamento automático entre ids da mesma proposição em casas diferentes (principalmente em proposições anteriores à nova versão da API da Câmara), nem definição de tema e apelido para as proposições fornecidos pelas APIs.

* Proposições disponíveis em `data/proposicoes.csv`:
  * PL 6299/2002 - PL do Veneno: Já aprovada no Senado e tramitando na Câmara
  * PL 3729/2004 - Lei do Licenciamento Ambiental: Atualmente arquivada na Câmara
  * PL 2646/2015 - Aumento do STF: Transformada em lei

Execução:
```
Rscript fetcher.R -i <input_filepath> -o <output_filepath>
```
Os argumentos a serem passados são os seguintes:
 * -i <input_filepath>: Caminho para o csv das proposições. O caminho default é `data/proposicoes.csv`;
 * -o <output_filepath>: Caminho para o csv de saída. O caminho default é `/data/versoes.csv`.

 ## Os dados

O arquivo de saída gerado pelo fetcher está em `data/versoes.csv` e possui as seguintes informações:
 * `id_proposicao`: identificador da proposição em uma determinada casa;
 * `casa`: casa do congresso (pode ser senado ou camara);
 * `data`: data da versão;
 * `descricao`: texto da tramitação sobre a versão;
 * `link_inteiro_teor`: link para o arquivo em pdf do texto da proposição;
 * `pagina_inicial`: número da página em que o texto de interesse começa.

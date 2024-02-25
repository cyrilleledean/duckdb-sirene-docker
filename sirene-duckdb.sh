#!/bin/bash

# Téléchargement DuckDB CLI, décompactage puis suppression du fichier compacté.

wget --no-check-certificate $DUCKDB_CLI && \
unzip duckdb_cli-linux-amd64.zip && \
rm duckdb_cli-linux-amd64.zip

if ! [ -f ./sirene/StockEtablissement_utf8.csv ]; then

  wget --no-check-certificate -O ./sirene/etablissement.zip $STOCK_ETABLISSEMENT && \
  unzip ./sirene/etablissement.zip -d ./sirene && \
  rm ./sirene/etablissement.zip

fi

if ! [ -f ./sirene/StockUniteLegale_utf8.csv ]; then

  wget --no-check-certificate -O ./sirene/unitelegale.zip $STOCK_UNITELEGALE && \
  unzip ./sirene/unitelegale.zip -d ./sirene && \
  rm ./sirene/unitelegale.zip

fi

./duckdb < ./sql/extract-export.sql
FROM debian:stable-slim

# Installation de librairies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         wget \
         unzip \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY sirene-duckdb.sh .
RUN chmod +x ./sirene-duckdb.sh

CMD [ "sh", "./sirene-duckdb.sh"]
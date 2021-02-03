FROM ubuntu:latest

# Enviroment-Variablen
ENV PBF_URL=https://download.geofabrik.de/europe/germany/thueringen-latest.osm.pbf
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=""
ENV POSTGRES_HOST=localhost
ENV POSTGRES_PORT=5432
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install --quiet -y osm2pgsql git wget python3 python3-psycopg2 python3-requests python3-yaml gdal-bin

# Carto-Daten
WORKDIR /usr/local/src/
RUN git clone https://github.com/gravitystorm/openstreetmap-carto.git && \
    chmod -R a+rwx /usr/local/src/openstreetmap-carto

COPY run.sh /run.sh
RUN chmod a+x /run.sh

RUN useradd -s /bin/bash osm

USER osm

ENTRYPOINT ["/run.sh"]

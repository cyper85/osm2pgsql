#!/bin/bash

if [[ -z "${POSTGRES_PASSWORD}" ]]; then
  LOCAL_POSTGRES_PASSWORD=""
else
  LOCAL_POSTGRES_PASSWORD="--password ${POSTGRES_PASSWORD}"
fi

wget -O /data.osm.pbf $PBF_URL

osm2pgsql --username $POSTGRES_USER --database $POSTGRES_DB $LOCAL_POSTGRES_PASSWORD --host $POSTGRES_HOST --port $POSTGRES_PORT --create --slim -G --hstore --tag-transform-script /usr/local/src/openstreetmap-carto/openstreetmap-carto.lua -C 2048 --number-processes ${THREADS:-4} -S /usr/local/src/openstreetmap-carto/openstreetmap-carto.style /data.osm.pbf
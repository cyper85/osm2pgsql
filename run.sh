#!/bin/bash

export PGPASS=$POSTGRES_PASSWORD

wget -O /tmp/data.osm.pbf $PBF_URL

osm2pgsql --username $POSTGRES_USER --database $POSTGRES_DB --host $POSTGRES_HOST --port $POSTGRES_PORT --create --slim -G --hstore --tag-transform-script /usr/local/src/openstreetmap-carto/openstreetmap-carto.lua -C 2048 --number-processes ${THREADS:-4} -S /usr/local/src/openstreetmap-carto/openstreetmap-carto.style /tmp/data.osm.pbf

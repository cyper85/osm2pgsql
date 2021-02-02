#!/bin/bash

export PGPASS="$POSTGRES_PASSWORD"
export PGPASSWORD="$POSTGRES_PASSWORD"

wget -O /tmp/data.osm.pbf "${PBF_URL}"

# Import ShapeFiles
python3 /usr/local/src/openstreetmap-carto/scripts/get-external-data.py --database "${POSTGRES_DB}" \
                                                                        --host "${POSTGRES_HOST}" \
                                                                        --port "${POSTGRES_PORT}" \
                                                                        --username "${POSTGRES_USER}" \
                                                                        --password "${POSTGRES_PASSWORD}" \
                                                                        --config /usr/local/src/openstreetmap-carto/external-data.yml \
|| echo "ShapeFile-Import with Errors"

# Import PBF-File
osm2pgsql --username "${POSTGRES_USER}" \
          --database "${POSTGRES_DB}" \
          --host "${POSTGRES_HOST}" \
          --port "${POSTGRES_PORT}" \
          --create \
          --slim \
          -G \
          --hstore \
          --tag-transform-script /usr/local/src/openstreetmap-carto/openstreetmap-carto.lua \
          -C 2048 \
          --number-processes "${THREADS:-4}" \
          -S /usr/local/src/openstreetmap-carto/openstreetmap-carto.style \
          /tmp/data.osm.pbf

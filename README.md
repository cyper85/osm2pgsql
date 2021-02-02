# Docker-OSM2PGSQL-Container

This is a container to import OpenStreetMap-Data for a [Mapnik-Tile-Server](https://cloud.docker.com/repository/docker/cyper85/mapnik/) in a [postgis-Database](https://hub.docker.com/r/cyper85/postgis).


## Installation

You need a [postGIS-Container](https://github.com/postgis/docker-postgis). For the importer you can use this Image from Docker-Hub [cyper85/osm2pgsql](https://hub.docker.com/r/cyper85/osm2pgsql).

```bash
# Create a Network to use the Postgis-Server in an other container
docker network create postgis-net

# Install a postgis-instance
docker run --detach --name test-postgis --network postgis-net postgis/postgis

# Install a osm2pgsql-instance
docker run --env POSTGRES_HOST=test-postgis --name test-osm2pgsql --network postgis-net cyper85/osm2pgsql
```

Or you build your own image from source:

```bash
# Download sources
git clone https://github.com/cyper85/osm2pgsql.git
cd osm2pgsql/

# Build it
docker build --tag osm2pgsql .

# Install an instance
docker run --name test-osm2pgsql --network postgis-net osm2pgsql
```

## Update Data
Simply restart the container:

```bash
docker start test-postgis 
```

## Additional parameter

env | default value | description 
------------ | ------------- | -------------
PBF_URL | https://download.geofabrik.de/europe/germany/thueringen-latest.osm.pbf | URL to PBF-File to import
POSTGRES_DB | postgres | Database-Name
POSTGRES_USER | postgres | Database-User
POSTGRES_PASSWORD |  | Database-Password
POSTGRES_HOST | localhost | Database-Hostname
POSTGRES_PORT | 5432 | Database-Port

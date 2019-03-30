FROM alpine:latest

USER root

# Enviroment-Variablen
ENV PBF_URL=https://download.geofabrik.de/europe/germany/thueringen-latest.osm.pbf
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=""
ENV POSTGRES_HOST=localhost
ENV POSTGRES_PORT=5432
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


ENV HOME /root
ENV OSM2PGSQL_VERSION 0.96.0

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories 
RUN	apk update

# Install the things we want to stick around
RUN apk add --no-cache libgcc libstdc++ boost-filesystem boost-system boost-thread expat libbz2 postgresql-libs libpq geos@testing proj4@testing lua5.2 lua5.2-libs

# Install develop tools and dependencies, build osm2pgsql and remove develop tools and dependencies
RUN apk add --no-cache make cmake expat-dev g++ git boost-dev zlib-dev bzip2-dev proj4-dev@testing 	geos-dev@testing lua5.2-dev postgresql-dev wget
RUN mkdir /usr/local/src

WORKDIR /usr/local/src 
RUN git clone --depth 1 --branch $OSM2PGSQL_VERSION https://github.com/openstreetmap/osm2pgsql.git 
RUN cd osm2pgsql 
RUN mkdir build 
RUN cd build
RUN cmake -DLUA_LIBRARY=/usr/lib/liblua-5.2.so.0 .. 
RUN make 
RUN make install 

# Carto-Daten
WORKDIR /usr/local/src/
RUN git clone https://github.com/gravitystorm/openstreetmap-carto.git

# Aufräumen
WORKDIR /usr/local/src
RUN rm -rf osm2pgsql
RUN apk --purge del make cmake git g++ boost-dev gdbm python3 boost-python3 python binutils gcc lua5.2-dev bzip2-dev expat-dev 	musl-dev libc-dev zlib-dev openssl-dev postgresql-dev proj4-dev

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
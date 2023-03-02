# FROM postgres:12

# # This is our time zone
# ENV TZ America/Vancouver

# # install PostGIS
# RUN apt-get update
# RUN apt-get install -y --no-install-recommends postgresql-12-postgis-3
# RUN apt-get install -y --no-install-recommends postgresql-12-postgis-3-dbgsym
# RUN apt-get install -y --no-install-recommends postgresql-12-postgis-3-scripts

# # Set the time zone
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# # Load the PostGIS extension into the database
# COPY load_postgis.sql docker-entrypoint-initdb.d/load_postgis.sql

# EXPOSE 5432
FROM postgres:15-bullseye

LABEL maintainer="PostGIS Project - https://postgis.net"

ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.3.2+dfsg-1.pgdg110+1

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           # ca-certificates: for accessing remote raster files;
           #   fix: https://github.com/postgis/docker-postgis/issues/307
           ca-certificates \
           \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin

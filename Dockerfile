FROM postgres:13

# This is our time zone
ENV TZ America/Vancouver

# install PostGIS
RUN apt-get update
RUN apt-get install -y --no-install-recommends postgresql-15-postgis-3
RUN apt-get install -y --no-install-recommends postgresql-15-postgis-3-dbgsym
RUN apt-get install -y --no-install-recommends postgresql-15-postgis-3-scripts

# Set the time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 5432

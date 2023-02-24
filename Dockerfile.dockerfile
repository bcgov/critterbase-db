FROM postgres:15.2

# This is our time zone
ENV TZ America/Vancouver

# install PostGIS
RUN apt-get update

# Set the time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 5432

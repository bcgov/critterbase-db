# This image provides a postgres installation from which to run backups
FROM --platform=linux/amd64 quay.io/fedora/postgresql-15


# Change timezone to PST for convenience
ENV TZ=PST8PDT

# Set the workdir to be root
WORKDIR /

# Load the backup scripts into the container (must be executable).
COPY backup.* /

# ========================================================================================================
# Install go-crond (from https://github.com/webdevops/go-crond)
#
# CRON Jobs in OpenShift:
#  - https://blog.danman.eu/cron-jobs-in-openshift/
# --------------------------------------------------------------------------------------------------------
ARG SOURCE_REPO=webdevops
ARG GOCROND_VERSION=23.2.0
ADD https://github.com/$SOURCE_REPO/go-crond/releases/download/$GOCROND_VERSION/go-crond.linux.amd64 /usr/bin/go-crond

USER root

RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/bin/mc
RUN chmod +x /usr/bin/mc
RUN chmod +x /usr/bin/go-crond
# ========================================================================================================

# ========================================================================================================
# Perform operations that require root privilages here ...
# --------------------------------------------------------------------------------------------------------
RUN echo $TZ > /etc/timezone

# ========================================================================================================

# The column command is missing from quay.io/fedora/postgresql-14:14
RUN dnf install -y util-linux

# Custom Addition: postgis extension

# install PostGIS
RUN apt-get update
RUN apt-get install -y --no-install-recommends postgresql-15-postgis-3
RUN apt-get install -y --no-install-recommends postgresql-15-postgis-3-dbgsym
RUN apt-get install -y --no-install-recommends postgresql-15-postgis-3-scripts


# Set the time zone

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Load the PostGIS extension into the database
COPY ../load_postgis.sql docker-entrypoint-initdb.d/load_postgis.sql

# Important - Reset to the base image's user account.
USER 26

# Set the default CMD.
CMD sh /backup.sh

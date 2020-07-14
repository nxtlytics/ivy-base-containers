# Base Dockerfile for all common images
# This image contains
# - Nexus auth script
# - Base APT repos for Nexus
# Ensure this image is built with --squash to reduce layer bloat!

FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TERM=linux

# Ensure system is up to date and install nice utilities to have
RUN apt-get update && \
    apt-get install -y \
        iputils-ping \
        curl \
        wget \
        vim-common

# Make directory for utilities and applications
RUN mkdir /opt/ssa && mkdir /app

# Add the nexus auth configuration - CircleCI generates this file
ADD .nexus_config /opt/ssa/

# Add nexus auth script (for setup of all repository types supported by Nexus)
ADD setup-nexus.sh /opt/ssa/

# CircleCI adds this file, used as a version marker for the base
RUN mkdir /opt/ssa/meta
ADD .VERSION /opt/ssa/meta/BASE_VERSION

# Setup Nexus APT repository
RUN bash /opt/ssa/setup-nexus.sh --apt

# Set the work directory for all future docker images
WORKDIR /app

# Base Dockerfile for all common images
# This image contains
# - Nexus auth script
# - Base APT repos for Nexus
# Ensure this image is built with --squash to reduce layer bloat!

FROM ubuntu:focal-20201106

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TERM=linux

# Ensure system is up to date and install nice utilities to have
RUN apt update && \
    apt install -y \
        iputils-ping \
        curl \
        wget \
        vim-common \
        software-properties-common

# Make directory for utilities and applications
RUN mkdir /opt/ivy && mkdir /app

# Add nexus auth script (for setup of all repository types supported by Nexus)
ADD setup-nexus.sh /opt/ivy/

# CircleCI adds this file, used as a version marker for the base
RUN mkdir /opt/ivy/meta
ADD .VERSION /opt/ivy/meta/BASE_VERSION

# Set the work directory for all future docker images
WORKDIR /app

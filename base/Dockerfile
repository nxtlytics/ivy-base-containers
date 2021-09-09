# Base Dockerfile for all common images
# This image contains
# - Nexus auth script
# - Base APT repos for Nexus
# Ensure this image is built with --squash to reduce layer bloat!

FROM ubuntu:focal-20210827

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV TERM=linux
ADD 01_nodoc /etc/dpkg/dpkg.conf.d/01_nodoc

# Ensure system is up to date and install nice utilities to have
RUN apt update && \
    apt install -y \
        iputils-ping \
        curl \
        unzip \
        wget \
        vim-common \
        software-properties-common && \
    apt autoremove -yqq --purge && \
    apt clean all && \
    rm -rf \
      /var/lib/apt/lists/* \
      /var/log/apt/* \
      /var/log/alternatives.log \
      /var/log/bootstrap.log \
      /var/log/dpkg.log \
      /var/tmp/* \
      /tmp/*

# Make directory for utilities and applications
RUN mkdir /opt/ivy && mkdir /app

# Add nexus auth script (for setup of all repository types supported by Nexus)
ADD setup-nexus.sh /opt/ivy/

# CircleCI adds this file, used as a version marker for the base
RUN mkdir /opt/ivy/meta
ADD .VERSION /opt/ivy/meta/BASE_VERSION

# Set the work directory for all future docker images
WORKDIR /app

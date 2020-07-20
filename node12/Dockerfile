FROM nxtlytics/docker-base:<TBD>

# Install tools
RUN curl -sL https://deb.nodesource.com/setup_12.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt-get install -y nodejs

ADD .VERSION /opt/ivy/meta/NODE10_VERSION

# Setup Nexus npm repository (see docker-base image for options)
RUN bash /opt/ivy/setup-nexus.sh --npm

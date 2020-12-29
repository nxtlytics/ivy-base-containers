FROM nxtlytics/base:v0.0.2

# Install tools
RUN curl -sL https://deb.nodesource.com/setup_12.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt-get install -y nodejs

ADD .VERSION /opt/ivy/meta/NODE10_VERSION

FROM nxtlytics/base:v0.0.7-test-00

# Install tools
RUN curl -sL https://deb.nodesource.com/setup_14.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt install -y nodejs && \
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

ADD .VERSION /opt/ivy/meta/NODEJS_VERSION

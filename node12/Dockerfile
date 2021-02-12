FROM nxtlytics/base:v0.0.6-test-02

# Install tools
RUN curl -sL https://deb.nodesource.com/setup_12.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt install -y nodejs

ADD .VERSION /opt/ivy/meta/NODE12_VERSION

FROM nxtlytics/jenkins-jdk:v0.0.7-test-08

ENV RUBY_INSTALL_VERSION=0.8.1
ENV RUBY_VERSION=2.7.2

# Ensure system is up to date and install tools
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ focal-proposed restricted main multiverse universe' > /etc/apt/sources.list.d/focal-proposed.list ; \
    apt update ; \
    apt install -y \
        autoconf \
        bison \
        build-essential \
        dpkg-dev \
        libdb-dev \
        libffi-dev \
        libgdbm6 \
        libgdbm-dev \
        libncurses5-dev \
        libqdbm-dev \
        libreadline6-dev \
        libssl-dev \
        libyaml-dev \
        zlib1g-dev ; \
    export GNU_ARCH="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ; \
    curl -o "ruby-install-${RUBY_INSTALL_VERSION}.tar.gz" -L "https://github.com/postmodern/ruby-install/archive/v${RUBY_INSTALL_VERSION}.tar.gz" ; \
    tar -xzvf "ruby-install-${RUBY_INSTALL_VERSION}.tar.gz" ; \
    cd "ruby-install-${RUBY_INSTALL_VERSION}/" ; \
    make install ; \
    hash -r ; \
    cd - ; \
    ruby-install --system ruby "${RUBY_VERSION}" -- --enable-shared --disable-install-doc --build="${GNU_ARCH}" ; \
    gem update --system ; \
    gem update ; \
    ruby --version ; \
    gem --version ; \
    bundle --version ; \
    apt autoremove -yqq --purge ; \
    apt clean all ; \
    rm -rf \
      /var/lib/apt/lists/* \
      /var/log/apt/* \
      /var/log/alternatives.log \
      /var/log/bootstrap.log \
      /var/log/dpkg.log \
      /var/tmp/* \
      /tmp/* \
      "/app/ruby-install-${RUBY_INSTALL_VERSION}/" \
      "/app/ruby-install-${RUBY_INSTALL_VERSION}.tar.gz"

ADD .VERSION /opt/ivy/meta/RUBY_VERSION

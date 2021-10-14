FROM nxtlytics/jenkins-jdk:v0.0.9-test01

# Ensure system is up to date and install tools
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ focal-proposed restricted main multiverse universe' > /etc/apt/sources.list.d/focal-proposed.list && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y \
        git \
        python3.7 \
        python3.7-venv \
        python3.7-dev \
        python3-pip && \
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.7 /tmp/get-pip.py && \
    hash -r && \
    python3.7 -m pip install pipenv && \
    python3.7 -m pip install poetry && \
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

ADD .VERSION /opt/ivy/meta/PYTHON37_VERSION

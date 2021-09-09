FROM nxtlytics/jenkins-jdk:v0.0.8-test-1

# Ensure system is up to date and install tools
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ focal-proposed restricted main multiverse universe' > /etc/apt/sources.list.d/focal-proposed.list && \
    apt update && \
    apt install -y \
        git \
        python3.8 \
        python3.8-venv \
        python3.8-dev \
        python3-pip && \
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.8 /tmp/get-pip.py && \
    hash -r && \
    python3.8 -m pip install pipenv && \
    python3.8 -m pip install poetry && \
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

ADD .VERSION /opt/ivy/meta/PYTHON38_VERSION

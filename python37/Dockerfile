FROM nxtlytics/base:<TBD>

# Ensure system is up to date and install tools
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ bionic-proposed restricted main multiverse universe' > /etc/apt/sources.list.d/bionic-proposed.list && \
    apt-get update && \
    apt-get install -y \
        git \
        python3.7 \
        python3.7-venv \
        python3.7-dev \
        python3-pip && \
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.7 /tmp/get-pip.py && \
    hash -r && \
    python3.7 -m pip install pipenv

ADD .VERSION /opt/ivy/meta/PYTHON37_VERSION

# Setup Nexus pip repository (see docker-base image for options)
RUN bash /opt/ivy/setup-nexus.sh --pip

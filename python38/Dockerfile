FROM nxtlytics/docker-base:<TBD>

# Ensure system is up to date and install tools
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ bionic-proposed restricted main multiverse universe' > /etc/apt/sources.list.d/bionic-proposed.list && \
    apt-get update && \
    apt-get install -y \
        git \
        python3.8 \
        python3.8-venv \
        python3.8-dev \
        python3-pip && \
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.8 /tmp/get-pip.py && \
    hash -r && \
    python3.8 -m pip install git+https://github.com/pypa/pipenv.git@d10b2a216a25623ba9b3e3c4ce4573e0d764c1e4

ADD .VERSION /opt/ssa/meta/PYTHON38_VERSION

# Setup Nexus pip repository (see docker-base image for options)
RUN bash /opt/ssa/setup-nexus.sh --pip

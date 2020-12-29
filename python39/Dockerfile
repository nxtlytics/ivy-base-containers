FROM nxtlytics/base:v0.0.2-test-1

# Ensure system is up to date and install tools
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ bionic-proposed restricted main multiverse universe' > /etc/apt/sources.list.d/bionic-proposed.list && \
    apt-get update && \
    apt-get install -y \
        git \
        python3.9 \
        python3.9-venv \
        python3.9-dev \
        python3-pip && \
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.9 /tmp/get-pip.py && \
    hash -r && \
    python3.9 -m pip install pipenv && \
    python3.9 -m pip install poetry

ADD .VERSION /opt/ivy/meta/PYTHON39_VERSION

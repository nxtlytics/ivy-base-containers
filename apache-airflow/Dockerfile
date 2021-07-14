FROM nxtlytics/python37:v0.0.7-test-08

# Airflow
ENV AIRFLOW_USER_HOME=/usr/local/airflow
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}
WORKDIR ${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

COPY Pipfile* ${AIRFLOW_USER_HOME}/
RUN set -ex \
    && buildDeps=' \
        freetds-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        libpq-dev \
    ' \
    && apt update -yqq \
    && apt dist-upgrade -yqq \
    && apt install -yqq --no-install-recommends \
        ${buildDeps} \
        freetds-bin \
        build-essential \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat \
        locales \
        supervisor \
        git \
        openssh-client \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
    && su airflow -l -c 'echo "login and logout"' \
    && chown -R airflow: ${AIRFLOW_USER_HOME} \
    && su airflow -l -c 'pipenv sync' \
    && apt purge --auto-remove -yqq ${buildDeps} \
    && apt autoremove -yqq --purge \
    && apt clean all \
    && rm -rf \
        /var/lib/apt/lists/* \
        /var/log/apt/* \
        /var/log/alternatives.log \
        /var/log/bootstrap.log \
        /var/log/dpkg.log \
        /var/tmp/* \
        /tmp/*

COPY *.sh /usr/local/bin/
COPY airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg
COPY config ${AIRFLOW_USER_HOME}/config/

EXPOSE 8080 5555 8793

ENTRYPOINT ["docker-entrypoint.sh"]

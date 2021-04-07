FROM nxtlytics/jdk:v0.0.7-test-01

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG AGENT_WORKDIR=/home/${user}/agent
ARG DOCKER_VERSION=20.10.5

# Ensure system is up to date and install tools
COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN echo '===> Make jenkins-agent executable' && \
    chmod +x /usr/local/bin/jenkins-agent && \
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave && \
    echo '===> Creating jenkins group, user and home' && \
    groupadd -g ${gid} ${group} && \
    useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user} && \
    echo '===> Installing apt dependencies' && \
    apt-get update && \
    apt-get install git-lfs && \
    echo '===> Installing docker client' && \
    curl -fSL "https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_VERSION}.tgz" -o docker.tgz && \
    tar -xzvf docker.tgz && \
    mv docker/* /usr/local/bin/ && \
    rmdir docker && \
    rm docker.tgz && \
    docker -v && \
    echo '===> Cleaning up' && \
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


ADD .VERSION /opt/ivy/meta/JENKINS_VERSION
USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}
WORKDIR /home/${user}
ENTRYPOINT ["jenkins-slave"]

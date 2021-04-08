FROM nxtlytics/jdk:v0.0.7-test-02

ENV user=jenkins
ENV group=jenkins
ENV uid=1000
ENV gid=1000
ENV AGENT_WORKDIR=/home/${user}/agent
ENV DOCKER_VERSION=20.10.5

# Ensure system is up to date and install tools
COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN echo '===> Make jenkins-agent executable' && \
    chmod +x /usr/local/bin/jenkins-agent && \
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave && \
    echo '===> Creating jenkins group, user and home' && \
    groupadd -g ${gid} ${group} && \
    useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user} && \
    mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR} && \
    chown -R jenkins: /home/${user} && \
    echo '===> Installing apt dependencies' && \
    apt-get update && \
    apt-get install git-lfs && \
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
ENTRYPOINT ["jenkins-slave"]

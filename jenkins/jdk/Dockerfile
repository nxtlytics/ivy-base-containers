FROM nxtlytics/jdk:v0.0.8-test-1

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
    echo '===> Installing nodejs apt repository' && \
    curl -sL https://deb.nodesource.com/setup_14.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt install -y nodejs && \
    echo '===> Installing apt dependencies' && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64 && \
    apt update && \
    apt install -y git-lfs jq python3-setuptools && \
    echo '===> Installing python pip' && \
    curl -sL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3.8 /tmp/get-pip.py && \
    echo '===> Installing pip dependencies' && \
    python3.8 -m pip install \
      boto3 \
      jira \
      PyGithub \
      pytz \
      requests && \
    echo '===> Installing reviewdog' && \
    REVIEWDOG_VERSION="$(curl -s 'https://api.github.com/repos/reviewdog/reviewdog/releases/latest' | jq -r .tag_name | tr -d 'v')" && \
    curl -sL \
      "https://github.com/reviewdog/reviewdog/releases/download/v${REVIEWDOG_VERSION}/reviewdog_${REVIEWDOG_VERSION}_Linux_x86_64.tar.gz" \
      -o /tmp/reviewdog.tar.gz && \
    tar -xzvf /tmp/reviewdog.tar.gz -C /tmp/ && \
    mv /tmp/reviewdog /usr/local/bin/reviewdog && \
    chmod +x /usr/local/bin/reviewdog && \
    reviewdog --version && \
    echo '===> Installing yq' && \
    YQ_VERSION="$(curl -s 'https://api.github.com/repos/mikefarah/yq/releases/latest' | jq -r .tag_name)" && \
    curl -sL \
      "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" \
      -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version && \
    echo '===> Installing docker-compose' && \
    DOCKER_COMPOSE_VERSION="$(curl -s 'https://api.github.com/repos/docker/compose/releases/latest' | jq -r .tag_name)" && \
    curl -sL \
      "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose --version && \
    echo '===> Installing packer' && \
    PACKER_VERSION="$(curl -s 'https://api.github.com/repos/hashicorp/packer/releases/latest' | jq -r .tag_name | tr -d 'v')" && \
    curl -sL \
      "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
      -o /tmp/packer.zip && \
    unzip /tmp/packer.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/packer && \
    packer --version && \
    echo '===> Installing terraform 0.12.31' && \
    curl -sL \
      "https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip" \
      -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform && \
    terraform --version && \
    echo '===> Installing jmeter and plugins' && \
    curl -sL 'https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.2.1.tgz' -o /opt/jmeter.tgz && \
    echo '====> untar jmeter.tgz' && \
    tar -xzvf /opt/jmeter.tgz -C /opt/ && \
    echo '====> untar moving jmeter to /opt/jmeter' && \
    mv -f /opt/apache-jmeter-5.2.1* /opt/jmeter && \
    echo '====> linking /opt/jmeter/bin/jmeter to /usr/bin/jmeter' && \
    ln -s /opt/jmeter/bin/jmeter /usr/bin/jmeter && \
    echo '====> downloading jmeter-plugins' && \
    curl -sL https://jmeter-plugins.org/files/packages/jpgc-casutg-2.9.zip -o /opt/jmeter-plugins.zip && \
    echo '====> unzip jmeter-plugins' && \
    unzip /opt/jmeter-plugins.zip -d /opt && cp -r /opt/lib /opt/jmeter/ && \
    echo '====> Removing jmeter.tgz and jmeter-plugins.zip' && \
    rm -rf /opt/lib /opt/jmeter.tgz /opt/jmeter-plugins.zip && \
    echo '===> Installing awscli v2' && \
    curl -sL 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o /tmp/awscli-exe-linux-x86_64.zip && \
    unzip /tmp/awscli-exe-linux-x86_64.zip -d /tmp/ && \
    /tmp/aws/install --update && \
    /usr/local/bin/aws --version && \
    echo '===> Installing azure cli' && \
    curl -sL https://aka.ms/InstallAzureCLIDeb -o /tmp/azure-cli.sh && \
    bash /tmp/azure-cli.sh && \
    az version && \
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

FROM nxtlytics/base:v0.0.7-test-06

ARG JAVA_MAJOR_VERSION=11
ENV MAVEN_HOME=/usr/share/maven
ARG MAVEN_VERSION=3.8.1
ARG MAVEN_SHA=0ec48eb515d93f8515d4abe465570dfded6fa13a3ceb9aab8031428442d9912ec20f066b2afbf56964ffe1ceb56f80321b50db73cf77a0e2445ad0211fb8e38d
ARG MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ENV GRADLE_HOME=/opt/gradle
ARG GRADLE_VERSION=6.8.3
ARG GRADLE_DOWNLOAD_SHA256=7faa7198769f872826c8ef4f1450f839ec27f0b4d5d1e51bade63667cbccd205

# Ensure system is up to date and install tools
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ focal-proposed restricted main multiverse universe' > /etc/apt/sources.list.d/focal-proposed.list && \
    echo '===> Installing OpenJDK 11' && \
    apt update && \
    apt install -y \
        git \
        "openjdk-${JAVA_MAJOR_VERSION}-dbg" \
        "openjdk-${JAVA_MAJOR_VERSION}-jdk-headless" && \
    echo "===> Installing Maven ${MAVEN_VERSION}" && \
    mkdir -p /usr/share/maven /usr/share/maven/ref && \
    curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum --check - && \
    tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 && \
    rm -f /tmp/apache-maven.tar.gz && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    echo "===> Installing Gradle " && \
    curl -fsSL -o gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - && \
    unzip gradle.zip && \
    rm gradle.zip && \
    mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" && \
    ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle && \
    hash -r && \
    mvn -v && \
    gradle --version && \
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


ADD .VERSION /opt/ivy/meta/JDK_VERSION

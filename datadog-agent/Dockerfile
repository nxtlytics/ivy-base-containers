FROM nxtlytics/base:v0.0.7-test-01

ADD utils /opt/utils/
RUN echo "===> Moving docker-entrypoint.sh to /usr/local/bin and making it exec" \
  && mv /opt/utils/docker-entrypoint.sh /usr/local/bin/ \
  && chmod +x /usr/local/bin/docker-entrypoint.sh \
  && echo "===> Installing DataDog Agent version 7" \
  && DD_API_KEY=fakekey123 \
  DD_AGENT_MAJOR_VERSION=7 \
  DD_INSTALL_ONLY=true \
  bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)" \
  && echo "===> Deleting all datadog checks so this container only runs the ones we manually configure" \
  && rm -rf /etc/datadog-agent/datadog.yaml /etc/datadog-agent/conf.d/* \
  && echo "===> Installing RDS Certificate Authority bundles" \
  && export RDS_CERTS_DIR='/usr/local/share/ca-certificates/RDS' \
  && mkdir -p "${RDS_CERTS_DIR}" \
  && chmod 0755 "${RDS_CERTS_DIR}" \
  && curl -sL 'https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem' | openssl x509 -noout -text -in /dev/stdin > "${RDS_CERTS_DIR}/commercial-rds-combined-ca-bundle.crt" \
  && curl -sL 'https://s3.us-gov-west-1.amazonaws.com/rds-downloads/rds-combined-ca-us-gov-bundle.pem' | openssl x509 -noout -text -in /dev/stdin > "${RDS_CERTS_DIR}/us-gov-rds-combined-ca-bundle.crt" \
  && chmod -R 0644 "${RDS_CERTS_DIR}"/* \
  && update-ca-certificates \
  && echo "===> Installing ytt see https://get-ytt.io/" \
  && curl -L 'https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.31.0/ytt-linux-amd64' -o /usr/local/bin/ytt \
  && chmod +x /usr/local/bin/ytt \
  && echo "===> Deleting temp files" \
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

ENTRYPOINT ["docker-entrypoint.sh"]

FROM nxtlytics/python38:v0.0.7-test-04

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
  && add-apt-repository ppa:alessandro-strada/ppa \
  && apt update \
  && apt install -y google-drive-ocamlfuse fuse curl jq \
  && apt clean all \
  && pip3 install --upgrade pip \
  && pip3 install notebook jupyterlab jupyterhub \
  && echo "user_allow_other" >> /etc/fuse.conf \
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

CMD ["docker-entrypoint.sh"]

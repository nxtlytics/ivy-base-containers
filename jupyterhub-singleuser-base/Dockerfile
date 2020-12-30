FROM nxtlytics/python38:v0.0.4

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
  && add-apt-repository ppa:alessandro-strada/ppa \
  && apt update \
  && apt install -y google-drive-ocamlfuse=0.7.23-0ubuntu1 fuse curl jq \
  && apt clean all \
  && pip3 install --upgrade pip \
  && pip3 install notebook jupyterlab jupyterhub \
  && echo "user_allow_other" >> /etc/fuse.conf \
  && rm -rf /var/log/apt/* /var/log/alternatives.log /var/log/bootstrap.log /var/log/dpkg.log

CMD ["docker-entrypoint.sh"]

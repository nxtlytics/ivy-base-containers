#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Airflow
export FERNET_KEY="${FERNET_KEY}"
export EXECUTOR="${EXECUTOR:-Celery}"
export POSTGRES_HOST="${AIRFLOW__CORE__DB_HOST}"
export POSTGRES_PORT="${AIRFLOW__CORE__DB_PORT:-5432}"
export POSTGRES_USER="${AIRFLOW__CORE__DB_USER}"
export POSTGRES_PASSWORD="${AIRFLOW__CORE__DB_PASS}"
export POSTGRES_DB="${AIRFLOW__CORE__DB_NAME}"
export REDIS_HOST="${REDIS_HOST}"
export REDIS_PORT="${REDIS_PORT:-6379}"
export REDIS_DBNUM="${REDIS_DBNUM:-1}"
export AIRFLOW_MODE="${AIRFLOW_MODE:-webserver}"
export STATSD_HOST="${STATSD_HOST:-172.17.0.1}"
export STATSD_PORT="${STATSD_PORT:-8125}"
export STATSD_PREFIX="${STATSD_PREFIX:-you-need-to-specify-a-prefix-for-this-airflow-instance}"
export AIRFLOW__WEBSERVER__AUTHENTICATE="${AIRFLOW_AUTHENTICATE:-False}"
export AIRFLOW__WEBSERVER__AUTH_BACKEND="${AIRFLOW_AUTH_BACKEND:-airflow.contrib.auth.backends.google_auth}"
export AIRFLOW__GOOGLE__CLIENT_ID="${OAUTH_CLIENT_ID:-nothing}"
export AIRFLOW__GOOGLE__CLIENT_SECRET="${OAUTH_CLIENT_SECRET:-nothing}"
export AIRFLOW__GOOGLE__OAUTH_CALLBACK_ROUTE="${OAUTH_CALLBACK_ROUTE:-/oauth2callback}"
export AIRFLOW__GOOGLE__DOMAIN="${GOOGLE_DOMAINS:-example1.com,example2.com}"
export AIRFLOW__CORE__LOGGING_CONFIG_CLASS="${LOGGING_CONFIG_CLASS:-airflow.config_templates.airflow_local_settings.DEFAULT_LOGGING_CONFIG}"
export AIRFLOW__CORE__HOSTNAME_CALLABLE="${HOSTNAME_CALLABLE:-socket:getfqdn}"

# Configure SENTRY
SENTRY_DSN="${SENTRY_DSN:-you-need-to-specify-a-sentry-dsn}"
if [[ "${SENTRY_DSN}" != 'you-need-to-specify-a-sentry-dsn' ]]; then
  export AIRFLOW__SENTRY__SENTRY_DSN="${SENTRY_DSN}"
  export SENTRY_ENVIRONMENT="${SENTRY_ENVIRONMENT:-develop}"
fi

mkdir -p /etc/supervisor/conf.d

cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:airflow]
command=/usr/local/bin/pipenv run airflow "${AIRFLOW_MODE}"
user=airflow
environment=HOME="/usr/local/airflow",USER="airflow"
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
autorestart=true
EOF

LOCAL_DAGS_ONLY="${LOCAL_DAGS_ONLY:-no}"
if [[ "${LOCAL_DAGS_ONLY}" == 'yes' || "${AIRFLOW_MODE}" == 'flower' ]]; then
  SETUP_GIT_SYNC='no'
else
  SETUP_GIT_SYNC='yes'
fi

case "${SETUP_GIT_SYNC}" in
  yes)
    # git-sync.sh
    REPO="${REPO}"
    BRANCH="${BRANCH}"
    DIR="${DIR}"
    REPO_HOST="${REPO_HOST}"
    REPO_PORT="${REPO_PORT:-22}"
    PRIVATE_KEY="${PRIVATE_KEY}"
    SYNC_TIME="${SYNC_TIME}"

    cat <<EOF >> /etc/supervisor/conf.d/supervisord.conf

[program:gitsync]
command=/usr/local/bin/git-sync.sh "${REPO}" "${BRANCH}" "${DIR}" "${REPO_HOST}" "${REPO_PORT}" "${PRIVATE_KEY}" "${SYNC_TIME}"
user=airflow
environment=HOME="/usr/local/airflow",USER="airflow"
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
autorestart=true
EOF
    ;;
  *)
    echo "No need to configure git-sync"
    ;;
esac

/usr/bin/supervisord

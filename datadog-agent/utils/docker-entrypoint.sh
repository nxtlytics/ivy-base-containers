#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

UTILS_DIR='/opt/utils'
POSTGRES_UTILS_DIR="${UTILS_DIR}/postgres"
DD_UTILS_DIR="${UTILS_DIR}/datadog"
DD_INTEGRATIONS_DIR='/etc/datadog-agent/conf.d'
POSTGRES_DD_DIR="${DD_INTEGRATIONS_DIR}/postgres.d"

# Replacing dd_config with value from environment variable `DD_CONFIG`
sed -i "s/REPLACEME/${DD_CONFIG}/g" "${DD_UTILS_DIR}/etc.yml"
# Rendering `etc.yml` to `datadog.yaml`
ytt -f "${DD_UTILS_DIR}/etc.yml" > /etc/datadog-agent/datadog.yaml

# Replacing `dbs` string with value from environment variable `POSTGRES_CONFIG`
sed -i "s/REPLACEME/${POSTGRES_CONFIG}/g" "${POSTGRES_UTILS_DIR}/postgres.conf.yml"
# Rendering `postgres.conf.yml` to `postgres.conf.yaml`
mkdir -p "${POSTGRES_DD_DIR}"
ytt -f "${POSTGRES_UTILS_DIR}/postgres.conf.yml" > "${POSTGRES_DD_DIR}/conf.yaml"

su -s /bin/bash -c "/opt/datadog-agent/bin/agent/agent run" dd-agent

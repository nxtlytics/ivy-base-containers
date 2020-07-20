#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO="${1}"
REF="${2}"
DIR="${3}"
REPO_HOST="${4}"
REPO_PORT="${5}"
PRIVATE_KEY="${6}"
SYNC_TIME="${7}"
PRIVATE_KEY_FILE="${HOME}/.ssh/id_ed25519"

mkdir -p ~/.ssh/

ssh-keyscan -p ${REPO_PORT} ${REPO_HOST} >> ~/.ssh/known_hosts

echo -e "${PRIVATE_KEY}" > "${PRIVATE_KEY_FILE}"

chmod 600 ~/.ssh/*

echo -e "Host ${REPO_HOST}\n  Port ${REPO_PORT}\n  IdentityFile ${PRIVATE_KEY_FILE}" > ~/.ssh/config

if [ -d "${DIR}" ]; then
  rm -rf $( find ${DIR} -mindepth 1 )
fi

git clone --depth 1 ${REPO} -b ${REF} ${DIR}

# to break the infinite loop when we receive SIGTERM
trap "exit 0" SIGTERM

cd ${DIR}

while true; do
  git fetch origin ${REF};
  git reset --hard origin/${REF};
  git clean -fd;
  date;
  sleep ${SYNC_TIME};
done

#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

GDRIVE_PATH="${GDRIVE_PATH:-/mnt/gdrive}"

# jovyan setup
JOVYAN_USER="${JUPYTERHUB_USER:-jovyan}"
HOME_DIR="/home/${JOVYAN_USER}"
GDFUSE_HOME='/root'
GDFUSE_PATH="${GDFUSE_HOME}/.gdfuse"
DEFAULT_LABEL_DIR="${GDFUSE_PATH}/default"
CONFIG_FILE="${GDFUSE_PATH}/default/config"
STATE_FILE="${GDFUSE_PATH}/default/state"

groupadd "${JOVYAN_USER}" || echo "group ${JOVYAN_USER} exists already"
useradd -s /bin/bash -d "${HOME_DIR}" --create-home -g "${JOVYAN_USER}" "${JOVYAN_USER}" || echo "user ${JOVYAN_USER} exists already"

su "${JOVYAN_USER}" -l -c "echo 'Testing login/logout of ${JOVYAN_USER}' && jupyter serverextension enable --py jupyterlab --user"

counter=0

until [ $counter -eq 5 ] || (id -u "${JOVYAN_USER}" &> /dev/null && id -g "${JOVYAN_USER}" &> /dev/null) ; do
  echo "user and group "${JOVYAN_USER}" are not ready yet"
  sleep $(( counter++ ))
done

PUID="$(id -u "${JOVYAN_USER}")"
PGID="$(id -g "${JOVYAN_USER}")"

if [ -z "${GDRIVE_CLIENT_ID}" ]; then
  echo "no GDRIVE_CLIENT_ID found -> EXIT"
  exit 1
elif [ -z "${GDRIVE_CLIENT_SECRET}" ]; then
  echo "no GDRIVE_CLIENT_SECRET found -> EXIT"
  exit 1
elif [ -z "${GDRIVE_CALLBACK_URL}" ]; then
  echo "no GDRIVE_CALLBACK_URL found -> EXIT"
  exit 1
elif [ -z "${GDRIVE_ACCESS_TOKEN}" ]; then
  echo "no GDRIVE_ACCESS_TOKEN found -> EXIT"
  exit 1
elif [ -z "${GDRIVE_REFRESH_TOKEN}" ]; then
  echo "no GDRIVE_REFRESH_TOKEN found -> EXIT"
  exit 1
else
  echo "initializing google-drive-ocamlfuse..."
  mkdir -p "${DEFAULT_LABEL_DIR}"
  cat <<EOF > "${CONFIG_FILE}"
acknowledge_abuse=false
apps_script_format=desktop
apps_script_icon=
async_upload_queue=false
async_upload_queue_max_length=0
async_upload_threads=10
autodetect_mime=true
background_folder_fetching=false
cache_directory=
client_id=${GDRIVE_CLIENT_ID}
client_secret=${GDRIVE_CLIENT_SECRET}
connect_timeout_ms=5000
curl_debug_off=false
data_directory=
debug_buffers=false
delete_forever_in_trash_folder=false
desktop_entry_as_html=false
desktop_entry_exec=
disable_trash=false
docs_file_extension=true
document_format=desktop
document_icon=
download_docs=true
drawing_format=desktop
drawing_icon=
form_format=desktop
form_icon=
fusion_table_format=desktop
fusion_table_icon=
keep_duplicates=false
large_file_read_only=false
large_file_threshold_mb=16
log_directory=
log_to=
lost_and_found=false
low_speed_limit=0
low_speed_time=0
map_format=desktop
map_icon=
max_cache_size_mb=512
max_download_speed=0
max_memory_cache_size=10485760
max_retries=8
max_upload_chunk_size=1099511627776
max_upload_speed=0
memory_buffer_size=1048576
metadata_cache_time=60
metadata_memory_cache=true
metadata_memory_cache_saving_interval=30
mv_keep_target=false
presentation_format=desktop
presentation_icon=
read_ahead_buffers=3
read_only=false
redirect_uri=${GDRIVE_CALLBACK_URL}
root_folder=
scope=
service_account_credentials_path=
service_account_user_to_impersonate=
spreadsheet_format=desktop
spreadsheet_icon=
sqlite3_busy_timeout=5000
stream_large_files=false
team_drive_id=
umask=0o022
verification_code=
write_buffers=false
EOF

  cat <<EOF > "${STATE_FILE}"
access_token_date=1970-01-01T00:00:00.000Z
auth_request_date=1970-01-01T00:00:00.000Z
auth_request_id=
last_access_token=${GDRIVE_ACCESS_TOKEN}
refresh_token=${GDRIVE_REFRESH_TOKEN}
saved_version=0.7.21
EOF

  chown -R root: "${GDFUSE_HOME}" "${GDFUSE_PATH}"
fi

MOUNT_OPTS=",allow_other${MOUNT_OPTS:-}"

# mount as the jovyan user
echo "mounting at ${GDRIVE_PATH}"
MY_DRIVE="${GDRIVE_PATH}/my-drive"
mkdir -p "${MY_DRIVE}"
chown -R "${JOVYAN_USER}:" "${MY_DRIVE}"

google-drive-ocamlfuse "${MY_DRIVE}" -f -o "uid=${PUID},gid=${PGID}${MOUNT_OPTS}" &

counter=0

until [ $counter -eq 5 ] || ls ${MY_DRIVE}/* &> /dev/null; do
  echo "${MY_DRIVE} is not working yet"
  sleep $(( counter++ ))
done

ACCESS_TOKEN="$(grep '^last_access_token=' "${STATE_FILE}" | cut -d '=' -f2)"

DRIVES=( $(curl -s 'https://www.googleapis.com/drive/v3/drives'  --header "Authorization: Bearer ${ACCESS_TOKEN}" --header 'Accept: application/json' --compressed | jq -r '.drives[] | [.id, .name] | @csv' | tr -d '"') )

declare -A ARRAY_DRIVES
for drive in "${DRIVES[@]}"; do
  ARRAY_DRIVES["$(cut -d ',' -f1 <<< "${drive}")"]="$(cut -d ',' -f2 <<< "${drive}")"
done

for id in "${!ARRAY_DRIVES[@]}"; do
  mkdir -p "${GDRIVE_PATH}/${ARRAY_DRIVES[${id}]}"
  chown -R "${JOVYAN_USER}:" "${GDRIVE_PATH}/${ARRAY_DRIVES[${id}]}"
  google-drive-ocamlfuse -label "${ARRAY_DRIVES[${id}]}" || true
  cp "${STATE_FILE}" "${GDFUSE_PATH}/${ARRAY_DRIVES[${id}]}/state"
  cp "${CONFIG_FILE}" "${GDFUSE_PATH}/${ARRAY_DRIVES[${id}]}/config"
  sed -i "s!team_drive_id=!team_drive_id=${id}!g" "${GDFUSE_PATH}/${ARRAY_DRIVES[${id}]}/config"
  google-drive-ocamlfuse -label "${ARRAY_DRIVES[${id}]}" "${GDRIVE_PATH}/${ARRAY_DRIVES[${id}]}" -f -o "uid=${PUID},gid=${PGID}${MOUNT_OPTS:-}" &
done

JUPYTERLAB_CMD="JUPYTERHUB_API_TOKEN=${JUPYTERHUB_API_TOKEN:-} JUPYTERHUB_CLIENT_ID=${JUPYTERHUB_CLIENT_ID:-} \
    JUPYTERHUB_OAUTH_CALLBACK_URL=${JUPYTERHUB_OAUTH_CALLBACK_URL:-} JUPYTERHUB_HOST=${JUPYTERHUB_HOST:-} \
    JUPYTERHUB_USER=${JUPYTERHUB_USER:-} JUPYTERHUB_SERVER_NAME=${JUPYTERHUB_SERVER_NAME:-} \
    JUPYTERHUB_API_URL=${JUPYTERHUB_API_URL:-} JUPYTERHUB_ACTIVITY_URL=${JUPYTERHUB_ACTIVITY_URL:-} \
    JUPYTERHUB_BASE_URL=${JUPYTERHUB_BASE_URL:-} JUPYTERHUB_SERVICE_PREFIX=${JUPYTERHUB_SERVICE_PREFIX:-} \
    JPY_API_TOKEN=${JPY_API_TOKEN:-} jupyterhub-singleuser ${@}"

echo "JUPYTERLAB_CMD is ${JUPYTERLAB_CMD}"

su "${JOVYAN_USER}" -l -c "${JUPYTERLAB_CMD}"

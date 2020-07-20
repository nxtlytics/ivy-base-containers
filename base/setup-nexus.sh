#!/usr/bin/env bash

# Source config
source $(dirname $0)/.nexus_config

NPM_TEST_PACKAGE="@ivy/cicd-test"
PYPI_TEST_PACKAGE="cicd-test"

# Library functions
bold=$(tput -Tvt100 bold)
norm=$(tput -Tvt100 sgr0)
function status() {
    local TEXT=${1}
    echo -n "${TEXT}"
}
function fail() {
    echo -e "                   [ ${bold}FAIL${norm} ]"
}
function finish() {
    echo -e "                   [ ${bold} OK ${norm} ]"
}
function check_tool() {
    local TOOL=${1}
    which ${TOOL} 2>&1 >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Missing \"$TOOL\"! Cannot continue." >&2
        return 1
    fi
}
function begin_step() {
    local STEP=${1}
    local TOOL=${2}
    status "Setting up ${1}..."
    check_tool ${TOOL}
    if [[ $? -ne 0 ]]; then
        fail
        echo "Cannot continue. Exiting with error."
        exit 1
    fi
}

# Check HTTP/HTTPS access to Nexus
function check_nexus() {
    status "Checking connectivity to Nexus..."
    curl -o /dev/null --retry 3 --silent --fail ${NEXUS_HOST} 2>&1
    if [[ $? -ne 0 ]]; then
        fail
        echo "Unable to contact Nexus." >&2
        exit 1
    fi
    finish
}


###########
# APT Setup
###########
function test_apt() {
    echo ""

}
function setup_apt() {
    begin_step "apt" "apt"
    echo

    test_apt
    [[ $? -eq 0 ]] && finish || fail
}

###############
# Maven Functions
###############
function test_mvn() {
    echo ""

}
function setup_mvn() {
    begin_step "mvn" "mvn"

    mkdir ~/.m2
    cat <<EOF > ~/.m2/settings.xml
<settings>
  <servers>
    <server>
      <id>nxtlytics</id>
      <username>${NEXUS_USER}</username>
      <password>${NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
EOF
    test_mvn
    [[ $? -eq 0 ]] && finish || fail
}

###############
# NPM Functions
###############
function test_npm() {
    NPM_OUTPUT=$(npm show ${NPM_TEST_PACKAGE} 2>&1)
    if [[ $? -ne 0 ]]; then
        echo "NPM can't find package \"${NPM_TEST_PACKAGE}\"."
        echo -e "Debug output:\n ${NPM_OUTPUT}\n"
        return 1
    fi
}
function setup_npm() {
    begin_step "npm" "npm"

    NPM_AUTH=$(echo -n "${NEXUS_USER}:${NEXUS_PASS}" | base64)
    cat <<EOF > ~/.npmrc
# Pull-only
registry=https://${NEXUS_HOST}${NPM_MIRROR_PATH}
_auth=${NPM_AUTH}
email=${USER_EMAIL}
always-auth=true

# Scoped registry config
@ivy:registry=https://${NEXUS_HOST}${NPM_HOSTED_PATH}
//${NEXUS_HOST}${NPM_HOSTED_PATH}:_auth=${NPM_AUTH}
//${NEXUS_HOST}${NPM_HOSTED_PATH}:email=${USER_EMAIL}
//${NEXUS_HOST}${NPM_HOSTED_PATH}:always-auth=true
EOF
    test_npm
    [[ $? -eq 0 ]] && finish || fail
}

###############
# Pip Functions
###############
function test_pip() {
    PIP_OUTPUT=$(pip search ${PYPI_TEST_PACKAGE} 2>&1)
    if [[ $? -ne 0 ]]; then
        echo "PIP can't find package \"${PYPI_TEST_PACKAGE}\"."
        echo -e "Debug output:\n ${PIP_OUTPUT}\n"
    fi
}
function setup_pip() {
    begin_step "Pip/Pipenv/Twine" "pip"
    mkdir -p ~/.config/pip
    cat <<EOF > ~/.config/pip/pip.conf
[global]
index = https://${NEXUS_HOST}${PYPI_MIRROR_PATH}/pypi
index-url = https://${NEXUS_HOST}${PYPI_MIRROR_PATH}/simple
EOF
    cat <<EOF > ~/.netrc
machine ${NEXUS_HOST}
  login ${NEXUS_USER}
  password ${NEXUS_PASS}
EOF
    chmod 0600 ~/.netrc

    # Twine (Pip uploads)
    cat <<EOF > ~/.pypirc
[distutils]
index-servers =
  nexus
[nexus]
repository: https://${NEXUS_HOST}/repository/pypi-hosted/
username: ${NEXUS_USER}
password: ${NEXUS_PASS}
EOF
    test_pip
    [[ $? -eq 0 ]] && finish || fail
}

echo "Setting up Nexus repositories..."
check_nexus

while (( "$#" )); do
  case "$1" in
    --apt)
      setup_apt
      shift
      ;;
    --mvn)
      setup_mvn
      shift
      ;;
    --npm)
      setup_npm
      shift
      ;;
    --pip)
      setup_pip
      shift
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    *) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
  esac
done

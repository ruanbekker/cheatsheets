#!/usr/bin/env bash
set -ex

# global variables
APP_USER=snake
APP_GROUP=snake
DATESTAMP="$(date +%F)"
TIMESTAMP="$(date +%s)"

function detect_previous_version(){
  if [ -f /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/.version ]
  then
    PREVIOUS_VERSION="$(cat /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/.version)"
  else
    PREVIOUS_VERSION="initial"
  fi
}

function debug_env(){
  echo "LIFECYCLE_EVENT=${LIFECYCLE_EVENT}" > /tmp/codedeploy.env
  echo "DEPLOYMENT_ID=${DEPLOYMENT_ID}" >> /tmp/codedeploy.env
  echo "APPLICATION_NAME=${APPLICATION_NAME}" >> /tmp/codedeploy.env
  echo "DEPLOYMENT_GROUP_NAME=${DEPLOYMENT_GROUP_NAME}" >> /tmp/codedeploy.env
  echo "DEPLOYMENT_GROUP_ID=${DEPLOYMENT_GROUP_ID}" >> /tmp/codedeploy.env
}

# functions
function user_and_group_check(){
  id -u ${APP_USER} &> /dev/null && EXIT_CODE=${?} || EXIT_CODE=${?}
  if [ ${EXIT_CODE} == 1 ]
    then
      sudo groupadd --gid 1002 ${APP_GROUP}
      sudo useradd --create-home --gid 1002 --shell /bin/bash ${APP_USER}
  fi
}

function create_backup() {
  sudo mkdir -p "/opt/backups/${DATESTAMP}"
  # on initial deploy skip backups
  if [ -d "/home/snake/app/current" ]
  then 
    TARGET_DIR=$(readlink -f /home/snake/app/current)
    sudo tar -zcf "/opt/backups/${DATESTAMP}/app-backup_${PREVIOUS_VERSION}.tar.gz ${TARGET_DIR}/"
  fi
}

function log_status(){
  echo "[${DATESTAMP}] before install step completed"
}

if [ "$DEPLOYMENT_GROUP_NAME" == "Staging" ]
then
    echo "Staging Environment"
fi

# detect previous version
detect_previous_version
# debug env vars for codedeploy
debug_env
# ensure the user exists
user_and_group_check
# create a backup
#create_backup
# log status
log_status

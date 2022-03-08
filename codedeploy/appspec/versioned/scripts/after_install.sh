#!/usr/bin/env bash
set -ex
APP_USER=snake
APP_GROUP=snake
DATESTAMP="$(date +%F)"
CD_INSTALL_TARGET=/home/snake/_target

function systemd_unit_file_check() {
  echo "copying systemd unit file in place"
  sudo cp "${CD_INSTALL_TARGET}/configs/python-app.service" /etc/systemd/system/python-app.service
  sudo systemctl daemon-reload
}

function remove_symlink(){
  if [ -d /home/snake/app/current ] 
  then
    sudo rm -rf /home/snake/app/current
    sudo mkdir -p /home/snake/app
  fi
}

function symlink_release() {
  sudo mkdir -p "/home/${APP_USER}/app/${DEPLOYMENT_ID}/configs"
  sudo mkdir -p "/home/${APP_USER}/app/${DEPLOYMENT_ID}/dependencies"
  sudo cp ${CD_INSTALL_TARGET}/configs/sample.env /home/${APP_USER}/app/${DEPLOYMENT_ID}/.env
  sudo cp ${CD_INSTALL_TARGET}/configs/hypercorn.toml /home/${APP_USER}/app/${DEPLOYMENT_ID}/configs/hypercorn.toml
  sudo cp ${CD_INSTALL_TARGET}/dependencies/requirements.pip /home/${APP_USER}/app/${DEPLOYMENT_ID}/dependencies/requirements.pip
  sudo cp -r ${CD_INSTALL_TARGET}/src/* /home/${APP_USER}/app/${DEPLOYMENT_ID}/
  sudo ln -s /home/${APP_USER}/app/${DEPLOYMENT_ID} /home/${APP_USER}/app/current
}

function install_dependencies(){
  sudo python3 -m pip install -r /home/${APP_USER}/app/current/dependencies/requirements.pip
}

function set_permissions() {
  sudo chown -R ${APP_USER}:${APP_GROUP} /home/${APP_USER}/
}

function log_status(){
  echo "[${DATESTAMP}] after install step completed"
}

# copy systemd unit file if not in place
systemd_unit_file_check

# remove symlink and version the installed target
remove_symlink
symlink_release

# install the dependencies
install_dependencies

# set permissions
set_permissions

# log status
log_status

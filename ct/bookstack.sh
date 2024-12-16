#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2024 community-scripts ORG
# Author: MickLesk (Canbiz)
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/BookStackApp/BookStack

# App Default Values
APP="Bookstack"
var_tags="organizer"
var_cpu="1"
var_ram="1024"
var_disk="4"
var_os="debian"
var_version="12"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -d /opt/bookstack ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  RELEASE=$(curl -s https://api.github.com/repos/BookStackApp/BookStack/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
  if [[ ! -f /opt/${APP}_version.txt ]] || [[ "${RELEASE}" != "$(cat /opt/${APP}_version.txt)" ]]; then
    msg_info "Stopping Apache2"
    systemctl stop apache2
    msg_ok "Services Stopped"

    msg_info "Updating ${APP} to ${RELEASE}"
    cp /opt/bookstack/.env /opt/.env
    wget -q "https://github.com/BookStackApp/BookStack/archive/refs/tags/v${RELEASE}.zip"
    unzip -q v${RELEASE}.zip
    mv BookStack-${RELEASE} /opt/bookstack
    mv /opt/.env /opt/bookstack/.env
    cd /opt/bookstack
    COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev &>/dev/null
    php artisan key:generate --force &>/dev/null
    php artisan migrate --force &>/dev/null
    echo "${RELEASE}" >/opt/${APP}_version.txt
    msg_ok "Updated ${APP}"

    msg_info "Starting Apache2"
    systemctl start apache2
    msg_ok "Started Apache2"

    msg_info "Cleaning Up"
    rm -rf v${RELEASE}.zip
    msg_ok "Cleaned"
    msg_ok "Updated Successfully"
  else
    msg_ok "No update required. ${APP} is already at ${RELEASE}"
  fi
  exit
}
start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}${CL}"

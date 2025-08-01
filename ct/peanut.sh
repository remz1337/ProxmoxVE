#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster) | Co-Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/Brandawg93/PeaNUT/

APP="PeaNUT"
var_tags="${var_tags:-network;ups;}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-3072}"
var_disk="${var_disk:-7}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /etc/systemd/system/peanut.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  RELEASE=$(curl -fsSL https://api.github.com/repos/Brandawg93/PeaNUT/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  if [[ ! -f /opt/${APP}_version.txt ]] || [[ "${RELEASE}" != "$(cat /opt/${APP}_version.txt)" ]]; then
    msg_info "Updating $APP to ${RELEASE}"
    systemctl stop peanut
    curl -fsSL "https://api.github.com/repos/Brandawg93/PeaNUT/tarball/${RELEASE}" -o "peanut.tar.gz"
    tar -xzf peanut.tar.gz -C /opt/peanut --strip-components=1
    rm peanut.tar.gz
    cd /opt/peanut
    $STD pnpm i
    $STD pnpm run build
    cp -r .next/static .next/standalone/.next/
    mkdir -p /opt/peanut/.next/standalone/config
    ln -sf /etc/peanut/settings.yml /opt/peanut/.next/standalone/config/settings.yml
    systemctl start peanut
    echo "${RELEASE}" >/opt/${APP}_version.txt
    msg_ok "Updated $APP to ${RELEASE}"
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
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"

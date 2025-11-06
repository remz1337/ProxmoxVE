#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster) | Co-Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/claabs/epicgames-freegames-node

APP="Epicgames-Freegames"
var_tags="${var_tags:-}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-4}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"
var_postfix_sat="${var_postfix_sat:-yes}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /etc/systemd/system/epicgames-freegames.timer ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Updating ${APP} LXC"
  RELEASE="https://github.com/claabs/epicgames-freegames-node/archive/refs/heads/master.tar.gz"
  #mkdir -p /opt/epicgames-freegames
  wget -qO epicgames-freegames.tar.gz "${RELEASE}"
  tar -xzf epicgames-freegames.tar.gz -C /opt/epicgames-freegames --strip-components 1 --overwrite
  rm -rf epicgames-freegames.tar.gz
  npm install --prefix /opt/epicgames-freegames
  msg_ok "Updated Successfully"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} is configured to be accessed by local tunnel. Please update the configuration to use a reverse proxy with the following URL.
         ${BL}http://${IP}:3000${CL} \n"

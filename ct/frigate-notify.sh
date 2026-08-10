#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster) | Co-Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/0x2142/frigate-notify

APP="Frigate-notify"
var_tags="${var_tags:-}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-128}"
var_disk="${var_disk:-2}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /etc/systemd/system/frigate-notify.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  
  if check_for_gh_release "frigate-notify" "0x2142/frigate-notify"; then
    msg_info "Stopping Service"
    systemctl stop frigate-notify
    msg_ok "Stopped Service"
    msg_info "Updating frigate-notify"
    RELEASE=$(curl -s https://api.github.com/repos/0x2142/frigate-notify/releases/latest |
      grep "tag_name" |
      awk '{print substr($2, 2, length($2)-3) }')
    cd /tmp

    curl -fsSL -o frigate-notify_Linux_amd64.zip \
      "https://github.com/0x2142/frigate-notify/releases/download/${RELEASE}/frigate-notify_Linux_amd64.zip"
    unzip -o frigate-notify_Linux_amd64.zip -d /opt/frigate-notify/
    rm frigate-notify_Linux_amd64.zip
	msg_ok "Updated Zitadel"

    msg_info "Starting Service"
    systemctl start frigate-notify
    msg_ok "Started Service"
    msg_ok "Updated successfully!"
  fi
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"

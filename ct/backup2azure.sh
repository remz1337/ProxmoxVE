#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster) | Co-Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/remz1337/Backup2Azure

# App Default Values
APP="Backup2Azure"
var_tags=""
var_cpu="1"
var_ram="512"
var_disk="4"
var_os="debian"
var_version="12"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"

# Core
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources 
  if [[ ! -f /etc/systemd/system/backup2azure.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Updating $APP LXC"
  RELEASE=$(curl -s https://api.github.com/repos/remz1337/Backup2Azure/releases/latest |
    grep "tag_name" |
    awk '{print substr($2, 2, length($2)-3) }')
  cd /tmp
  curl -o Backup2Azure.tar.gz -fsSLO https://api.github.com/repos/remz1337/Backup2Azure/tarball/$RELEASE
  tar -xzf Backup2Azure.tar.gz -C /opt/Backup2Azure/ --strip-components 1
  rm Backup2Azure.tar.gz
  msg_ok "Updated $APP LXC"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"

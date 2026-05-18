#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster) | Co-Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/getnora-io/nora

APP="Nora"
var_tags="${var_tags:-files}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-4}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"
var_unprivileged="${var_unprivileged:-1}"
#var_postfix_sat="${var_postfix_sat:-yes}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources 
  if [[ ! -f /etc/systemd/system/nora.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Updating $APP LXC"
  # RELEASE=$(curl -s https://api.github.com/repos/getnora-io/nora/releases/latest |
    # grep "tag_name" |
    # awk '{print substr($2, 2, length($2)-3) }')
  # cd /tmp
  # curl -LO https://github.com/getnora-io/nora/releases/download/${RELEASE}/nora-linux-amd64
  # chmod +x nora-linux-amd64
  
  systemctl stop nora
  rm /usr/local/bin/nora
  # mv nora-linux-amd64 /usr/local/bin/nora
  fetch_and_deploy_gh_release "nora" "getnora-io/nora" "singlefile" "latest" "/usr/local/bin/nora" "nora-linux-amd64"
  systemctl start nora
  
  msg_ok "Updated $APP LXC"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"

#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: MickLesk (Canbiz)
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/searxng/searxng

APP="SearXNG"
var_tags="${var_tags:-search}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
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
  if [[ ! -d /usr/local/searxng/searxng-src ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  sed -i 's/^\([[:space:]]*limiter:\)[[:space:]]*true/\1 false/' /etc/searxng/settings.yml
  if cd /usr/local/searxng/searxng-src && git pull | grep -q 'Already up to date'; then
    msg_ok "There is currently no update available."
  fi
  exit
}
start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8888${CL}"

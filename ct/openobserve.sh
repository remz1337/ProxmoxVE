#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://openobserve.ai/

APP="OpenObserve"
var_tags="${var_tags:-monitoring}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-3}"
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
    if [[ ! -d /opt/openobserve/ ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_info "Updating $APP"
    systemctl stop openobserve
    LATEST=$(curl -fsSL https://api.github.com/repos/openobserve/openobserve/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    tar zxvf <(curl -fsSL https://github.com/openobserve/openobserve/releases/download/$LATEST/openobserve-${LATEST}-linux-amd64.tar.gz) -C /opt/openobserve
    systemctl start openobserve
    msg_ok "Updated $APP"
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:5080${CL}"

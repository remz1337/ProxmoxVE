#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Authors: tteck (tteckster) | Co-Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/coder/code-server

APP="Coder-Code-Server"
var_tags="${var_tags}"
var_cpu="${var_cpu:-4}"
var_ram="${var_ram:-4096}"
var_disk="${var_disk:-10}"
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
    if [[ ! -f /lib/systemd/system/code-server@.service ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi

    VERSION=$(curl -fsSL https://api.github.com/repos/coder/code-server/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
    msg_info "Installing Code-Server v${VERSION}"
	systemctl stop code-server@"$USER"
    curl -fOL https://github.com/coder/code-server/releases/download/v"$VERSION"/code-server_"${VERSION}"_amd64.deb &>/dev/null
    dpkg -i code-server_"${VERSION}"_amd64.deb &>/dev/null
    rm -rf code-server_"${VERSION}"_amd64.deb
    systemctl restart code-server@"$USER"
    msg_ok "Installed Code-Server v${VERSION} on $hostname"

    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"

echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://$IP:8680${CL} \n"
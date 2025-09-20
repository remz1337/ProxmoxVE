#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2025 remz1337
# Authors: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/Alibaba-NLP/DeepResearch

APP="DeepResearch"
var_tags="${var_tags:-ai}"
var_cpu="${var_cpu:-12}"
var_ram="${var_ram:-18432}"
var_disk="${var_disk:-100}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"
var_nvidia_passthrough="${var_nvidia_passthrough:-yes}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -f /etc/systemd/system/deepresearch.service ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_error "To update DeepResearch, create a new container and transfer your configuration."
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: vhsdream
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://fluidcalendar.com

APP="fluid-calendar"
var_tags="${var_tags:-calendar,tasks}"
var_cpu="${var_cpu:-3}"
var_ram="${var_ram:-4096}"
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

    if [[ ! -d /opt/fluid-calendar ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi

    RELEASE=$(curl -fsSL https://api.github.com/repos/dotnetfactory/fluid-calendar/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
    if [[ "${RELEASE}" != "$(cat /opt/${APP}_version.txt)" ]] || [[ ! -f /opt/${APP}_version.txt ]]; then
        msg_info "Stopping $APP"
        systemctl stop fluid-calendar.service
        msg_ok "Stopped $APP"

        msg_info "Updating $APP to v${RELEASE}"
        cp /opt/fluid-calendar/.env /opt/fluid.env
        rm -rf /opt/fluid-calendar
        tmp_file=$(mktemp)
        curl -fsSL "https://github.com/dotnetfactory/fluid-calendar/archive/refs/tags/v${RELEASE}.zip" -o "$tmp_file"
        $STD unzip $tmp_file
        mv ${APP}-${RELEASE}/ /opt/fluid-calendar
        mv /opt/fluid.env /opt/fluid-calendar/.env
        cd /opt/fluid-calendar
        export NEXT_TELEMETRY_DISABLED=1
        $STD npm install --legacy-peer-deps
        $STD npm run prisma:generate
        $STD npx prisma migrate deploy
        $STD npm run build:os
        msg_ok "Updated $APP to v${RELEASE}"

        msg_info "Starting $APP"
        systemctl start fluid-calendar.service
        msg_ok "Started $APP"

        msg_info "Cleaning Up"
        rm -rf $tmp_file
        msg_ok "Cleanup Completed"

        echo "${RELEASE}" >/opt/${APP}_version.txt
        msg_ok "Update Successful"
    else
        msg_ok "No update required. ${APP} is already at v${RELEASE}"
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

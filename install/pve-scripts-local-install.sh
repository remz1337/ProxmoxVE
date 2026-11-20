#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: michelroegl-brunner
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/remz1337/ProxmoxVE-Local/tree/remz

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

NODE_VERSION="24" setup_nodejs
fetch_and_deploy_gh_branch "ProxmoxVE-Local" "remz1337/ProxmoxVE-Local" "remz"

msg_info "Installing PVE Scripts local"
$STD bash /opt/ProxmoxVE-Local/scripts/install-system.sh
msg_ok "Installed PVE Scripts local with private runtime and SSH-only management"

motd_ssh
customize
cleanup_lxc

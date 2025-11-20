#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Authors: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/browser-use/browser-use

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies (Patience)"
#$STD apt-get install -y {git,python3.13,python3.13-dev,python3.13-venv,python3-pip,build-essential,libpq5,libz-dev,libssl-dev,postgresql-client}
msg_ok "Installed Dependencies"


msg_info "Downloading browser-use source"
fetch_and_deploy_gh_release "browser-use" "browser-use/browser-use" "tarball" "latest" "/opt/browser-use"
msg_ok "Downloaded browser-use source"

msg_info "Installing browser-use"
###
msg_ok "Installed browser-use"

motd_ssh
customize

msg_info "Cleaning up"
apt-get -y autoremove
apt-get -y autoclean
msg_ok "Cleaned"
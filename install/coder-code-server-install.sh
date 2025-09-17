#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Authors: MickLesk (CanbiZ)
# Co-Authors: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/coder/code-server

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies (Patience)"
$STD apt-get install -y {curl,git}
msg_ok "Installed Dependencies"

VERSION=$(curl -fsSL https://api.github.com/repos/coder/code-server/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
msg_info "Installing Code-Server v${VERSION}"
curl -fOL https://github.com/coder/code-server/releases/download/v"$VERSION"/code-server_"${VERSION}"_amd64.deb &>/dev/null
dpkg -i code-server_"${VERSION}"_amd64.deb &>/dev/null
rm -rf code-server_"${VERSION}"_amd64.deb
mkdir -p ~/.config/code-server/
systemctl enable -q --now code-server@"$USER"
cat <<EOF >~/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8680
auth: none
password: 
cert: false
EOF
systemctl restart code-server@"$USER"
msg_ok "Installed Code-Server v${VERSION}"

motd_ssh
customize

msg_info "Cleaning up"
apt-get -y autoremove
apt-get -y autoclean
msg_ok "Cleaned"


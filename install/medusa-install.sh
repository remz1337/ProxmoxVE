#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# Co-Author: MickLesk (Canbiz)
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/pymedusa/Medusa

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y \
  git-core \
  mediainfo

cat <<EOF >/etc/apt/sources.list.d/non-free.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
EOF
$STD apt-get update
$STD apt-get install -y unrar
rm /etc/apt/sources.list.d/non-free.list
msg_ok "Installed Dependencies"

msg_info "Installing Medusa"
$STD git clone https://github.com/pymedusa/Medusa.git /opt/medusa
msg_ok "Installed Medusa"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/medusa.service
[Unit]
Description=Medusa Daemon
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /opt/medusa/start.py -q --nolaunch --datadir=/opt/medusa
TimeoutStopSec=25
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now medusa
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

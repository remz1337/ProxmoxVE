#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# Co-Author: remz1337
# License: MIT
# https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y unzip
msg_ok "Installed Dependencies"

RELEASE=$(curl -s https://api.github.com/repos/0x2142/frigate-notify/releases/latest |
  grep "tag_name" |
  awk '{print substr($2, 2, length($2)-3) }')

msg_info "Downloading frigate-notify ${RELEASE}"
mkdir -p /opt/frigate-notify
cd /tmp
curl -fsSL -o frigate-notify_Linux_amd64.zip \
  "https://github.com/0x2142/frigate-notify/releases/download/${RELEASE}/frigate-notify_Linux_amd64.zip"
unzip -o frigate-notify_Linux_amd64.zip -d /opt/frigate-notify/
rm frigate-notify_Linux_amd64.zip
cd /opt/frigate-notify
curl -fsSL \
  -o example-config.yml \
  https://raw.githubusercontent.com/0x2142/frigate-notify/refs/heads/main/example-config.yml
cp example-config.yml config.yml
msg_ok "Downloaded frigate-notify"


msg_info "Creating Services"
# Create API service
cat > /etc/systemd/system/frigate-notify.service <<EOF
[Unit]
Description=frigate-notify Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/frigate-notify
ExecStart=/opt/frigate-notify/frigate-notify
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start API service
systemctl enable -q --now frigate-notify.service

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

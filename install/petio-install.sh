#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://petio.tv/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing MongoDB 4.4"
curl -fsSL "https://www.mongodb.org/static/pgp/server-4.4.asc" | gpg --dearmor >/usr/share/keyrings/mongodb-server-4.4.gpg
# Determine OS ID
OS_ID=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

if [ "$OS_ID" = "debian" ]; then
  echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] http://repo.mongodb.org/apt/debian $(grep '^VERSION_CODENAME=' /etc/os-release | cut -d'=' -f2)/mongodb-org/4.4 main" >/etc/apt/sources.list.d/mongodb-org-4.4.list
else
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] https://repo.mongodb.org/apt/ubuntu $(grep '^VERSION_CODENAME=' /etc/os-release | cut -d'=' -f2)/mongodb-org/4.4 multiverse" >/etc/apt/sources.list.d/mongodb-org-4.4.list
fi

$STD apt-get update
$STD apt-get install -y mongodb-org
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
systemctl enable -q --now mongod
msg_ok "MongoDB 4.4 Installed"

msg_info "Installing Petio"
useradd -M --shell=/bin/false petio
mkdir /opt/Petio
curl -fsSL "https://petio.tv/releases/latest" -o "petio-latest.zip"
$STD unzip petio-latest.zip -d /opt/Petio
rm -rf petio-latest.zip
chown -R petio:petio /opt/Petio
msg_ok "Installed Petio"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/petio.service
[Unit]
Description=Petio a content request system
After=network.target mongod.service

[Service]
Type=simple
User=petio
Restart=on-failure
RestartSec=1
ExecStart=/opt/Petio/bin/petio-linux

[Install]
WantedBy=multi-user.target


EOF
systemctl enable -q --now petio
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://syncthing.net/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Syncthing"
curl -fsSL -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
sh -c 'echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" > /etc/apt/sources.list.d/syncthing.list'
$STD apt-get update
$STD apt-get install -y syncthing
$STD systemctl enable syncthing@root.service
systemctl start syncthing@root.service
sleep 5
sed -i "{s/127.0.0.1:8384/0.0.0.0:8384/g}" /root/.local/state/syncthing/config.xml
systemctl restart syncthing@root.service
msg_ok "Installed Syncthing"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

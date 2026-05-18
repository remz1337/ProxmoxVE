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

msg_info "Installing Nora ${RELEASE}"
# RELEASE=$(curl -s https://api.github.com/repos/getnora-io/nora/releases/latest |
  # grep "tag_name" |
  # awk '{print substr($2, 2, length($2)-3) }')

# RELEASE=$(curl -s https://api.github.com/repos/getnora-io/nora/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
# cd /tmp
# curl -LO https://github.com/getnora-io/nora/releases/download/${RELEASE}/nora-linux-amd64
# chmod +x nora-linux-amd64
# mv nora-linux-amd64 /usr/local/bin/nora
fetch_and_deploy_gh_release "nora" "getnora-io/nora" "singlefile" "latest" "/usr/local/bin/nora" "nora-linux-amd64"
msg_ok "Installed Nora ${RELEASE}"

msg_info "Creating Services"
cat <<EOF >/etc/systemd/system/nora.service
[Unit]
Description=NORA Artifact Registry
Documentation=https://getnora.dev
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
#User=nora
#Group=nora
ExecStart=/usr/local/bin/nora serve
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartSec=5

# Environment
Environment=RUST_LOG=info
Environment=NORA_HOST=0.0.0.0
Environment=NORA_PORT=4000
#Environment=NORA_PUBLIC_URL=https://nora.example.com
Environment=NORA_STORAGE_PATH=/var/lib/nora
#Environment=NORA_CONFIG_PATH=/etc/nora/config.toml
#EnvironmentFile=-/etc/nora/nora.env

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/nora
PrivateTmp=true
PrivateDevices=true
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true

# Resource limits
LimitNOFILE=65535
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable -q --now nora
sleep 2
msg_ok "Created Services"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

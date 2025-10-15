#!/usr/bin/env bash

# Copyright (c) 2021-2025 remz1337
# Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/prashalruchiranga/arxiv-mcp-server

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing dependencies"
$STD apt install -y git
PYTHON_VERSION="3.13" setup_uv
msg_ok "Installed dependencies"

msg_info "Installing Arxiv-MCP"
cd /opt
git clone https://github.com/prashalruchiranga/arxiv-mcp-server.git
cd arxiv-mcp-server
uv venv --python=python3.13
source .venv/bin/activate
uv sync
msg_ok "Installed Arxiv-MCP"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"

#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Authors: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/Significant-Gravitas/AutoGPT

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies (Patience)"
$STD apt-get install -y {git,python3.13,python3.13-dev,python3.13-venv,python3-pip,build-essential,libpq5,libz-dev,libssl-dev,postgresql-client}
msg_ok "Installed Dependencies"

NODE_VERSION="22" setup_nodejs

msg_info "Setting up environment"
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export DEBIAN_FRONTEND=noninteractive
export POETRY_HOME=/opt/poetry
export POETRY_NO_INTERACTION=1
export POETRY_VIRTUALENVS_CREATE=true
export POETRY_VIRTUALENVS_IN_PROJECT=true
export PATH=/opt/poetry/bin:$PATH
msg_ok "Setup environment"

msg_info "Downloading Frigate source"
fetch_and_deploy_gh_release "autogpt" "Significant-Gravitas/AutoGPT" "tarball" "latest" "/opt/autogpt"
msg_ok "Downloaded Frigate source"

msg_info "Installing AutoGPT Backend"
pip3 install poetry --break-system-packages

# Copy and install dependencies
#COPY autogpt_platform/autogpt_libs /app/autogpt_platform/autogpt_libs
#COPY autogpt_platform/backend/poetry.lock autogpt_platform/backend/pyproject.toml /app/autogpt_platform/backend/
#WORKDIR /app/autogpt_platform/backend
cd /opt/autogpt/autogpt_platform/backend
poetry install --no-ansi --no-root

# Generate Prisma client
#COPY autogpt_platform/backend/schema.prisma ./
#COPY autogpt_platform/backend/backend/data/partial_types.py ./backend/data/partial_types.py
#cd /opt/autogpt/autogpt_platform/backend/schema.prisma
poetry run prisma generate

#ENV PATH="/app/autogpt_platform/backend/.venv/bin:$PATH"

#RUN mkdir -p /app/autogpt_platform/autogpt_libs
#RUN mkdir -p /app/autogpt_platform/backend
#mkdir -p /opt/autogpt/autogpt_platform/autogpt_libs
#mkdir -p /opt/autogpt/autogpt_platform/backend

#Copy env file
cd /opt/autogpt/autogpt_platform
cp .env.default .env

#cd /opt/autogpt/autogpt_platform/backend
#poetry run rest
make run-backend

msg_ok "Installed AutoGPT Backend"

motd_ssh
customize

msg_info "Cleaning up"
apt-get -y autoremove
apt-get -y autoclean
msg_ok "Cleaned"
#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies (Patience)"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y ca-certificates-java
msg_ok "Installed Dependencies"

msg_info "Installing OpenJDK"
$STD apt install wget lsb-release -y
$STD wget https://packages.microsoft.com/config/debian/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
$STD dpkg -i packages-microsoft-prod.deb
$STD apt update
$STD apt install -y msopenjdk-21
sudo update-java-alternatives --set msopenjdk-21-amd64
rm packages-microsoft-prod.deb
msg_ok "Installed OpenJDK"

msg_info "Installing PostgreSQL"
$STD apt-get install -y postgresql
DB_NAME="keycloak"
DB_USER="keycloak"
DB_PASS="$(openssl rand -base64 18 | tr -dc 'a-zA-Z0-9' | cut -c1-13)"
$STD sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
$STD sudo -u postgres psql -c "CREATE DATABASE $DB_NAME WITH OWNER $DB_USER ENCODING 'UTF8';"
$STD sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
msg_ok "Installed PostgreSQL"

RELEASE=$(curl -s https://api.github.com/repos/keycloak/keycloak/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
msg_info "Installing Keycloak v$RELEASE"
cd /opt
wget -q https://github.com/keycloak/keycloak/releases/download/$RELEASE/keycloak-$RELEASE.tar.gz
$STD tar -xvf keycloak-$RELEASE.tar.gz
mv keycloak-$RELEASE keycloak
msg_ok "Installed Keycloak"

msg_info "Creating Service"
service_path="/etc/systemd/system/keycloak.service"
echo "[Unit]
Description=Keycloak
Requires=network.target
After=syslog.target network-online.target
[Service]
Type=idle
User=root
WorkingDirectory=/opt/keycloak
ExecStart=/opt/keycloak/bin/kc.sh start
ExecStop=/opt/keycloak/bin/kc.sh stop
Restart=always
RestartSec=3
Environment="KC_DB=postgres"
Environment="KC_DB_USERNAME=$DB_USER"
Environment="KC_DB_PASSWORD=$DB_PASS"
Environment="KC_HTTP_ENABLED=true"
Environment="KC_HOSTNAME_STRICT=false"
#Environment="KC_HOSTNAME=keycloak.example.com"
#Environment="KC_PROXY_HEADERS=xforwarded"
Environment="KC_BOOTSTRAP_ADMIN_USERNAME=tmpadm"
Environment="KC_BOOTSTRAP_ADMIN_PASSWORD=admin123"
[Install]
WantedBy=multi-user.target" >$service_path
$STD systemctl enable --now keycloak.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/build.func)
# Copyright (c) 2021-2026 remz1337
# Author: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://gitea.com/gitea/act_runner/

APP="Gitea-Runner"
var_tags="${var_tags:-git}"
var_cpu="${var_cpu:-4}"
var_ram="${var_ram:-4096}"
var_disk="${var_disk:-8}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

check_for_gitea_release() {
  local current_version latest_version

  current_version=$(
    /usr/local/bin/gitea-runner --version 2>/dev/null \
      | grep -oP 'v?\d+\.\d+\.\d+' \
      | head -1 \
      | sed 's/^v//'
  )

  latest_version=$(
    curl -fsSL "https://gitea.com/api/v1/repos/gitea/runner/releases/latest" \
      | jq -r '.tag_name' \
      | sed 's/^v//'
  )

  if [[ "$current_version" == "$latest_version" ]]; then
    msg_ok "Already running latest version (${latest_version})"
    return 1
  fi

  msg_info "Current version: ${current_version:-unknown}"
  msg_info "Latest version: ${latest_version}"
  return 0
}

fetch_and_deploy_gitea_runner() {
  local asset_url

  asset_url=$(
    curl -fsSL "https://gitea.com/api/v1/repos/gitea/runner/releases/latest" |
    jq -r '
      .assets[]
      | select(.name | test("^gitea-runner-.*-linux-amd64$"))
      | .browser_download_url
    '
  )

  curl -fsSL "$asset_url" -o /usr/local/bin/gitea-runner
  chmod +x /usr/local/bin/gitea-runner
}

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -f /usr/local/bin/gitea-runner ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  if check_for_gitea_release; then
    msg_info "Stopping service"
    systemctl stop act_runner
    msg_ok "Service stopped"

    rm -rf /usr/local/bin/gitea-runner
    fetch_and_deploy_gitea_runner

    msg_info "Starting service"
    systemctl start act_runner
    msg_ok "Service started"

    msg_ok "Updated successfully!"
  fi
}

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"

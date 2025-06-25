#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Authors: tteck (tteckster) | Co-Author: remz1337
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://frigate.video/

APP="Frigate"
var_tags="${var_tags:-nvr}"
var_cpu="${var_cpu:-4}"
var_ram="${var_ram:-4096}"
var_disk="${var_disk:-45}"
var_os="${var_os:-debian}"
var_version="${var_version:-11}"
var_unprivileged="${var_unprivileged:-1}"
var_nvidia_passthrough="${var_nvidia_passthrough:-yes}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /etc/systemd/system/frigate.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
    
  FRIGATE=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/blakeblackshear/frigate/releases/latest)
  FRIGATE=${FRIGATE##*/}
  
  GO2RTC=$(curl -s https://api.github.com/repos/AlexxIT/go2rtc/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
  
  FFMPEG="n6.1-latest"
  
  #Once nodejs is installed, can be updated via apt.
  #NODE=$(curl -s https://api.github.com/repos/nodejs/node/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')

  UPD=$(whiptail --backtitle "Proxmox VE Helper Scripts" --title "SUPPORT" --radiolist --cancel-button Exit-Script "Spacebar = Select" 11 58 3 \
    "1" "Frigate $FRIGATE" ON \
    "2" "go2rtc $GO2RTC" OFF \
    "3" "ffmpeg $FFMPEG" OFF \
    3>&1 1>&2 2>&3)

  header_info
  #Update Frigate
  if [ "$UPD" == "1" ]; then
    #Ensure enough resources
    if (whiptail --backtitle "Proxmox VE Helper Scripts" --title "Update Frigate" --yesno "Does the LXC have at least 4vCPU  and 4096MiB RAM?" 10 58); then
      CONTINUE=1
    else
      CONTINUE=0
      exit-script
    fi

    echo -e "\n ⚠️  Ensure you set 4vCPU & 4096MiB RAM minimum!!! \n"
    msg_info "Stopping Frigate"
    systemctl stop frigate.service
    msg_ok "Stopped Frigate"

    msg_info "Updating Frigate to $FRIGATE (Patience)"
    python3 -m pip install --upgrade pip

RELEASE=$(curl -s https://api.github.com/repos/blakeblackshear/frigate/releases/latest | jq -r '.tag_name')
msg_ok "Stop spinner to prevent segmentation fault"
msg_info "Installing Frigate $RELEASE (Perseverance)"
if [ -n "$SPINNER_PID" ] && ps -p $SPINNER_PID > /dev/null; then kill $SPINNER_PID > /dev/null; fi
cd ~
#mkdir -p /opt/frigate/models
rm -rf /opt/frigate/web/*
wget -q https://github.com/blakeblackshear/frigate/archive/refs/tags/${RELEASE}.tar.gz -O frigate.tar.gz
tar -xzf frigate.tar.gz -C /opt/frigate --strip-components 1 --overwrite
rm -rf frigate.tar.gz
cd /opt/frigate
rm -f /wheels/*.whl
pip3 wheel --wheel-dir=/wheels -r /opt/frigate/docker/main/requirements-wheels.txt
cp -a /opt/frigate/docker/main/rootfs/. /
export TARGETARCH="amd64"
echo 'libc6 libraries/restart-without-asking boolean true' | debconf-set-selections
sed -i 's|gpg --dearmor -o /etc/apt/trusted.gpg.d/google|gpg --yes --dearmor -o /etc/apt/trusted.gpg.d/google|' /opt/frigate/docker/main/install_deps.sh
/opt/frigate/docker/main/install_deps.sh
apt update
ln -svf /usr/lib/btbn-ffmpeg/bin/ffmpeg /usr/local/bin/ffmpeg
ln -svf /usr/lib/btbn-ffmpeg/bin/ffprobe /usr/local/bin/ffprobe
pip3 install -U /wheels/*.whl
ldconfig
pip3 install -r /opt/frigate/docker/main/requirements-dev.txt
/opt/frigate/.devcontainer/initialize.sh
make version
cd /opt/frigate/web
npm install
npm run build
cp -r /opt/frigate/web/dist/* /opt/frigate/web/
#cp -r /opt/frigate/config/. /config
sed -i '/^s6-svc -O \.$/s/^/#/' /opt/frigate/docker/main/rootfs/etc/s6-overlay/s6-rc.d/frigate/run
# cat <<EOF >/config/config.yml
# mqtt:
  # enabled: false
# cameras:
  # test:
    # ffmpeg:
      # # hwaccel_args: preset-vaapi
      # inputs:
        # - path: /media/frigate/person-bicycle-car-detection.mp4
          # input_args: -re -stream_loop -1 -fflags +genpts
          # roles:
            # - detect
            # - rtmp
    # detect:
      # height: 1080
      # width: 1920
      # fps: 5
# EOF
ln -sf /config/config.yml /opt/frigate/config/config.yml
# if [[ "$CTTYPE" == "0" ]]; then
  # sed -i -e 's/^kvm:x:104:$/render:x:104:root,frigate/' -e 's/^render:x:105:root$/kvm:x:105:/' /etc/group
# else
  # sed -i -e 's/^kvm:x:104:$/render:x:104:frigate/' -e 's/^render:x:105:$/kvm:x:105:/' /etc/group
# fi
# echo "tmpfs   /tmp/cache      tmpfs   defaults        0       0" >> /etc/fstab
msg_ok "Installed Frigate $RELEASE"

msg_info "Building Nginx with Custom Modules"
/opt/frigate/docker/main/build_nginx.sh
sed -e '/s6-notifyoncheck/ s/^#*/#/' -i /opt/frigate/docker/main/rootfs/etc/s6-overlay/s6-rc.d/nginx/run
ln -sf /usr/local/nginx/sbin/nginx  /usr/local/bin/nginx
msg_ok "Built Nginx"

msg_info "Installing Tempio"
sed -i 's|/rootfs/usr/local|/usr/local|g' /opt/frigate/docker/main/install_tempio.sh
/opt/frigate/docker/main/install_tempio.sh
ln -sf /usr/local/tempio/bin/tempio /usr/local/bin/tempio
msg_ok "Installed Tempio"

    msg_info "Starting Frigate"
    systemctl start frigate.service
    msg_ok "Started Frigate"

    msg_ok "$FRIGATE Update Successful"
    echo -e "\n ⚠️  Ensure you set resources back to normal settings \n"
    exit
  fi
  #Update go2rtc
  if [ "$UPD" == "2" ]; then
    msg_info "Stopping go2rtc"
    systemctl stop go2rtc.service
    msg_ok "Stopped go2rtc"

    msg_info "Updating go2rtc to $GO2RTC"
    mkdir -p /usr/local/go2rtc/bin
    cd /usr/local/go2rtc/bin
    #Get latest release
    wget -O go2rtc "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_amd64"
    chmod +x go2rtc
    msg_ok "Updated go2rtc"

    msg_info "Starting go2rtc"
    systemctl start go2rtc.service
    msg_ok "Started go2rtc"
    msg_ok "$GO2RTC Update Successful"
    exit
  fi
  #Update ffmpeg
  if [ "$UPD" == "3" ]; then
    msg_info "Stopping Frigate and go2rtc"
    systemctl stop frigate.service go2rtc.service
    msg_ok "Stopped Frigate and go2rtc"

    msg_info "Updating ffmpeg to $FFMPEG"
    apt install xz-utils
    mkdir -p /usr/lib/btbn-ffmpeg
    wget -qO btbn-ffmpeg.tar.xz "https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-n6.1-latest-linux64-gpl-6.1.tar.xz"
    tar -xf btbn-ffmpeg.tar.xz -C /usr/lib/btbn-ffmpeg --strip-components 1
    rm -rf btbn-ffmpeg.tar.xz /usr/lib/btbn-ffmpeg/doc /usr/lib/btbn-ffmpeg/bin/ffplay
    msg_ok "Updated ffmpeg"

    msg_info "Starting Frigate and go2rtc"
    systemctl start frigate.service go2rtc.service
    msg_ok "Started Frigate and go2rtc"
    msg_ok "$FFMPEG Update Successful"
    exit
  fi
}

start
build_container
description

msg_info "Setting Container to Normal Resources"
pct set $CTID -memory 1024
pct set $CTID -cores 2
msg_ok "Set Container to Normal Resources"
msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:5000${CL}"
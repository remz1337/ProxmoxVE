#!/usr/bin/env bash

# Copyright (c) 2021-2025 remz1337
# Authors: remz1337
# License: MIT | https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE
# Source: https://github.com/Alibaba-NLP/DeepResearch

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies (Patience)"
$STD apt-get install -y git
msg_ok "Installed Dependencies"

msg_info "Setting up environment"
cd ~ && echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
source .bashrc
export TARGETARCH="amd64"
export CCACHE_DIR=/root/.ccache
export CCACHE_MAXSIZE=2G
# http://stackoverflow.com/questions/48162574/ddg#49462622
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
# https://askubuntu.com/questions/972516/debian-frontend-environment-variable
export DEBIAN_FRONTEND=noninteractive
# Globally set pip break-system-packages option to avoid having to specify it every time
export PIP_BREAK_SYSTEM_PACKAGES=1
# https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(Native-GPU-Support)
export NVIDIA_VISIBLE_DEVICES=all
export NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"
# Disable tokenizer parallelism warning
# https://stackoverflow.com/questions/62691279/how-to-disable-tokenizers-parallelism-true-false-warning/72926996#729>
export TOKENIZERS_PARALLELISM=true
# https://github.com/huggingface/transformers/issues/27214
export TRANSFORMERS_NO_ADVISORY_WARNINGS=1
# Set OpenCV ffmpeg loglevel to fatal: https://ffmpeg.org/doxygen/trunk/log_8h.html
export OPENCV_FFMPEG_LOGLEVEL=8
# Set HailoRT to disable logging
export HAILORT_LOGGER_PATH=NONE
msg_ok "Setup environment"

msg_info "Installing Pip"
wget -q https://bootstrap.pypa.io/get-pip.py -O get-pip.py
$STD python3 get-pip.py "pip"
msg_ok "Installed Pip"

source <(curl -s https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/nvidia.func)
nvidia_installed=$(check_nvidia_drivers_installed)
if [ $nvidia_installed == 1 ]; then
  check_nvidia_drivers_version
  echo -e "Nvidia drivers detected. Version ${NVD_VER}"
  msg_info "Installing Nvidia Dependencies"
  os=""
  if [ $PCT_OSTYPE == "debian" ]; then
    os="debian$PCT_OSVERSION"
  elif [ $PCT_OSTYPE == "ubuntu" ]; then
    os_ver=$(echo "$var_version" | sed 's|\.||g')
    os="ubuntu$os_ver"
  fi
  check_cuda_version
  TARGET_CUDA_VER=$(echo $NVD_VER_CUDA | sed 's|\.|-|g')
  $STD apt update
  $STD apt install -y gnupg
  $STD apt-key del 7fa2af80
  wget -q https://developer.download.nvidia.com/compute/cuda/repos/${os}/x86_64/cuda-keyring_1.1-1_all.deb
  $STD dpkg -i cuda-keyring_1.1-1_all.deb
  $STD apt install -y software-properties-common
  $STD apt update
  $STD add-apt-repository -y contrib
  rm cuda-keyring_1.1-1_all.deb
#  if grep -qR "Acquire::http::Proxy" /etc/apt/apt.conf.d/ && [ -f "/etc/apt/sources.list.d/cuda-${os}-x86_64.list" ]; then
#    sed -i "s|https://developer|http://HTTPS///developer|g" /etc/apt/sources.list.d/cuda-${os}-x86_64.list
#  fi
#  $STD apt update && sleep 1
  #Cap to CUDA 12
  if [[ "${NVD_MAJOR_CUDA}" -gt 12 ]]; then
    TARGET_CUDA_VER=12
    NVD_MAJOR_CUDA=12
  fi
  $STD apt update
  $STD apt install -qqy "cuda-toolkit-$TARGET_CUDA_VER"
  $STD apt install -qqy "cudnn-cuda-$NVD_MAJOR_CUDA"
  export PATH=/usr/local/cuda/bin:${PATH:+:${PATH}}
  export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
  echo "PATH=${PATH}"  >> ~/.bashrc
  echo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> ~/.bashrc
  source ~/.bashrc
  ldconfig
  #$STD pip3 uninstall -y onnxruntime onnxruntime-openvino
  #$STD pip3 install onnxruntime-gpu
  msg_ok "Installed Nvidia Dependencies"
else
  echo -e "GPU required for inference"
  exit
fi

msg_info "Downloading DeepResearch"
git clone https://github.com/Alibaba-NLP/DeepResearch.git
msg_ok "Downloaded DeepResearch"

msg_info "Installing DeepResearch"
cd DeepResearch
$STD pip3 install -r requirements.txt
#Test with
#vllm serve "Alibaba-NLP/Tongyi-DeepResearch-30B-A3B"
msg_ok "Installed DeepResearch"

msg_info "Creating Services"
cat <<EOF >/etc/systemd/system/deepresearch.service
[Unit]
Description=DeepResearch agent

[Service]
Type=oneshot
ExecStart=/bin/bash -c '/bin/mkdir -p /dev/shm/logs/{frigate,go2rtc,nginx} && /bin/touch /dev/shm/logs/{frigate/current,go2rtc/current,nginx/current} && /bin/chmod -R 777 /dev/shm/logs'

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now deepresearch
sleep 3
msg_ok "Created Services"

motd_ssh
customize

msg_info "Cleaning up"
apt-get -y autoremove
apt-get -y autoclean
msg_ok "Cleaned"

#!/usr/bin/env bash

# Copyright (c) 2021-2025 remz1337
# Authors: remz1337
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/vllm-project/vllm

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies (Patience)"
$STD apt-get install -y git build-essential python3-dev
msg_ok "Installed Dependencies"

msg_info "Setting Up Hardware Acceleration"
$STD apt-get -y install {va-driver-all,ocl-icd-libopencl1,intel-opencl-icd,vainfo,intel-gpu-tools}
if [[ "$CTTYPE" == "0" ]]; then
  chgrp video /dev/dri
  chmod 755 /dev/dri
  chmod 660 /dev/dri/*
  sed -i -e 's/^kvm:x:104:$/render:x:104:root,frigate/' -e 's/^render:x:105:root$/kvm:x:105:/' /etc/group
else
  sed -i -e 's/^kvm:x:104:$/render:x:104:frigate/' -e 's/^render:x:105:$/kvm:x:105:/' /etc/group
fi
msg_ok "Set Up Hardware Acceleration"

msg_info "Installing Pip"
wget -q https://bootstrap.pypa.io/get-pip.py -O get-pip.py
$STD python3 get-pip.py "pip"
msg_ok "Installed Pip"

msg_info "Installing vLLM"
$STD pip3 install flashinfer-python uv
#$STD pip3 install vllm
$STD uv venv --python 3.12 --seed
$STD source .venv/bin/activate
$STD uv pip install vllm --torch-backend=auto

#https://huggingface.co/docs/hub/security-tokens
#HF_TOKEN=abc123
#git config --global credential.helper store
#hf auth login --add-to-git-credential --token $HF_TOKEN

#vllm serve "Qwen/Qwen3-0.6B" --max_model_len 4096 --max_num_seqs 64
msg_ok "Installed vLLM"

motd_ssh
customize

msg_info "Cleaning up"
apt-get -y autoremove
apt-get -y autoclean
msg_ok "Cleaned"
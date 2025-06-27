#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/remz1337/ProxmoxVE/raw/remz/LICENSE

function header_info() {
  clear
  cat <<"EOF"
   __  __          __      __          __   _  ________   _____                 _               
  / / / /___  ____/ /___ _/ /____     / /  | |/ / ____/  / ___/___  ______   __(_)_______  _____
 / / / / __ \/ __  / __ `/ __/ _ \   / /   |   / /       \__ \/ _ \/ ___/ | / / / ___/ _ \/ ___/
/ /_/ / /_/ / /_/ / /_/ / /_/  __/  / /___/   / /___    ___/ /  __/ /   | |/ / / /__/  __(__  ) 
\____/ .___/\__,_/\__,_/\__/\___/  /_____/_/|_\____/   /____/\___/_/    |___/_/\___/\___/____/  
    /_/                                                                                         

EOF
}
set -eEuo pipefail
YW=$(echo "\033[33m")
BL=$(echo "\033[36m")
RD=$(echo "\033[01;31m")
CM='\xE2\x9C\x94\033'
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")
header_info
echo "Loading..."
whiptail --backtitle "Proxmox VE Helper Scripts" --title "Proxmox VE LXC Updater" --yesno "This Will Update LXC Containers. Proceed?" 10 58
NODE=$(hostname)
EXCLUDE_MENU=()
MSG_MAX_LENGTH=0
while read -r TAG ITEM; do
  OFFSET=2
  ((${#ITEM} + OFFSET > MSG_MAX_LENGTH)) && MSG_MAX_LENGTH=${#ITEM}+OFFSET
  EXCLUDE_MENU+=("$TAG" "$ITEM " "OFF")
done < <(pct list | awk 'NR>1')
excluded_containers=$(whiptail --backtitle "Proxmox VE Helper Scripts" --title "Containers on $NODE" --checklist "\nSelect containers to skip from updates:\n" 16 $((MSG_MAX_LENGTH + 23)) 6 "${EXCLUDE_MENU[@]}" 3>&1 1>&2 2>&3 | tr -d '"')

function needs_reboot() {
  local container=$1
  local os=$(pct config "$container" | awk '/^ostype/ {print $2}')
  local reboot_required_file="/var/run/reboot-required.pkgs"
  if [ -f "$reboot_required_file" ]; then
    if [[ "$os" == "ubuntu" || "$os" == "debian" ]]; then
      if pct exec "$container" -- [ -s "$reboot_required_file" ]; then
        return 0
      fi
    fi
  fi
  return 1
}

# function update_container() {
  # container=$1
  # header_info
  # name=$(pct exec "$container" hostname)
  # os=$(pct config "$container" | awk '/^ostype/ {print $2}')
  # if [[ "$os" == "ubuntu" || "$os" == "debian" || "$os" == "fedora" ]]; then
    # disk_info=$(pct exec "$container" df /boot | awk 'NR==2{gsub("%","",$5); printf "%s %.1fG %.1fG %.1fG", $5, $3/1024/1024, $2/1024/1024, $4/1024/1024 }')
    # read -ra disk_info_array <<<"$disk_info"
    # echo -e "${BL}[Info]${GN} Updating ${BL}$container${CL} : ${GN}$name${CL} - ${YW}Boot Disk: ${disk_info_array[0]}% full [${disk_info_array[1]}/${disk_info_array[2]} used, ${disk_info_array[3]} free]${CL}\n"
  # else
    # echo -e "${BL}[Info]${GN} Updating ${BL}$container${CL} : ${GN}$name${CL} - ${YW}[No disk info for ${os}]${CL}\n"
  # fi
  # case "$os" in
  # alpine) pct exec "$container" -- ash -c "apk -U upgrade" ;;
  # archlinux) pct exec "$container" -- bash -c "pacman -Syyu --noconfirm" ;;
  # fedora | rocky | centos | alma) pct exec "$container" -- bash -c "dnf -y update && dnf -y upgrade" ;;
  # ubuntu | debian | devuan) pct exec "$container" -- bash -c "apt-get update 2>/dev/null | grep 'packages.*upgraded'; apt list --upgradable && apt-get -yq dist-upgrade 2>&1; rm -rf /usr/lib/python3.*/EXTERNALLY-MANAGED" ;;
  # opensuse) pct exec "$container" -- bash -c "zypper ref && zypper --non-interactive dup" ;;
  # esac
# }

function update_container_service() {
  #1) Detect service using the service name in the update command
  #eg. https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/ct/frigate.sh
  pushd $(mktemp -d)
  pct pull "$container" /usr/bin/update update 2>/dev/null
  service=$(cat update | sed 's|.*/ct/||g' | sed 's|\.sh).*||g')
  popd

  #1.1) If update script not detected, return
  if [ -z "${service}" ]; then
    echo "Update script not found"
	return
  else
    echo "Detected service: ${service}"
  fi
  
  #2) Extract service build/update resource requirements from config/installation file
  #var_cpu="${var_cpu:-4}"
  #var_cpu="4"
  #var_cpu=4
  #var_ram="${var_ram:-4096}"
  #pct set $CTID -memory 1024
  #pct set $CTID -cores 2
  script=$(curl -fsSL https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/ct/${service}.sh)
  #build_cpu=$(echo "$script" | grep "var_cpu" | sed 's|.*:-||g' | sed 's|}.*||g')
  #build_ram=$(echo "$script" | grep "var_ram" | sed 's|.*:-||g' | sed 's|}.*||g')
  build_cpu=$(echo "$script" | grep -m 1 "var_cpu" | sed 's|.*=||g' | sed 's|"||g' | sed 's|.*var_cpu:-||g' | sed 's|}||g')
  build_ram=$(echo "$script" | grep -m 1 "var_ram" | sed 's|.*=||g' | sed 's|"||g' | sed 's|.*var_ram:-||g' | sed 's|}||g')
  #run_cpu=(echo "$script" | grep "pct set \$CTID -cores" | sed 's|.*cores ||g')
  #run_ram=(echo "$script" | grep "pct set \$CTID -memory" | sed 's|.*memory ||g')
  
  #Test if all values are valid (>0)
  #if no run values, assume same as build
  #if no build values, assume current values are ok
  
  #3) if build resources are different than run resources, then:
  #3.1) Shutdown LXC
  #3.2) Update resources for build
  #3.3) Start LXC
  
  #4) Update service, using the update command
  
  #5) if build resources are different than run resources, then:
  #5.1) Shutdown LXC
  #5.2) Update resources back to normal (run)
  #5.3) Start LXC
  
  
  
  container=$1
  header_info
  name=$(pct exec "$container" hostname)
  os=$(pct config "$container" | awk '/^ostype/ {print $2}')
  if [[ "$os" == "ubuntu" || "$os" == "debian" || "$os" == "fedora" ]]; then
    disk_info=$(pct exec "$container" df /boot | awk 'NR==2{gsub("%","",$5); printf "%s %.1fG %.1fG %.1fG", $5, $3/1024/1024, $2/1024/1024, $4/1024/1024 }')
    read -ra disk_info_array <<<"$disk_info"
    echo -e "${BL}[Info]${GN} Updating ${BL}$container${CL} : ${GN}$name${CL} - ${YW}Boot Disk: ${disk_info_array[0]}% full [${disk_info_array[1]}/${disk_info_array[2]} used, ${disk_info_array[3]} free]${CL}\n"
  else
    echo -e "${BL}[Info]${GN} Updating ${BL}$container${CL} : ${GN}$name${CL} - ${YW}[No disk info for ${os}]${CL}\n"
  fi
  case "$os" in
  alpine) pct exec "$container" -- ash -c "update" ;;
  archlinux) pct exec "$container" -- bash -c "update" ;;
  fedora | rocky | centos | alma) pct exec "$container" -- bash -c "update" ;;
  ubuntu | debian | devuan) pct exec "$container" -- bash -c "update" ;;
  opensuse) pct exec "$container" -- bash -c "update" ;;
  esac
}

containers_needing_reboot=()
header_info
for container in $(pct list | awk '{if(NR>1) print $1}'); do
  if [[ " ${excluded_containers[@]} " =~ " $container " ]]; then
    header_info
    echo -e "${BL}[Info]${GN} Skipping ${BL}$container${CL}"
    sleep 1
  else
    status=$(pct status $container)
    template=$(pct config $container | grep -q "template:" && echo "true" || echo "false")
    if [ "$template" == "false" ] && [ "$status" == "status: stopped" ]; then
      echo -e "${BL}[Info]${GN} Starting${BL} $container ${CL} \n"
      pct start $container
      echo -e "${BL}[Info]${GN} Waiting For${BL} $container${CL}${GN} To Start ${CL} \n"
      sleep 5
      #update_container $container
	  update_container_service $container
      echo -e "${BL}[Info]${GN} Shutting down${BL} $container ${CL} \n"
      pct shutdown $container &
    elif [ "$status" == "status: running" ]; then
      #update_container $container
	  update_container_service $container
    fi
    if pct exec "$container" -- [ -e "/var/run/reboot-required" ]; then
      # Get the container's hostname and add it to the list
      container_hostname=$(pct exec "$container" hostname)
      containers_needing_reboot+=("$container ($container_hostname)")
    fi
  fi
done
wait
header_info
echo -e "${GN}The process is complete, and the containers have been successfully updated.${CL}\n"
if [ "${#containers_needing_reboot[@]}" -gt 0 ]; then
  echo -e "${RD}The following containers require a reboot:${CL}"
  for container_name in "${containers_needing_reboot[@]}"; do
    echo "$container_name"
  done
fi
echo ""

<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/images/logo.png" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h2 align="center">Proxmox VE Helper-Scripts</h2>
  <p align="center">A Community Legacy in Memory of @tteck</p>
  <p align="center">
    <a href="https://helper-scripts.com">
      <img src="https://img.shields.io/badge/Website-4c9b3f?style=for-the-badge&logo=github&logoColor=white" alt="Website" />
    </a>
    <a href="https://discord.gg/jsYVk5JBxq">
      <img src="https://img.shields.io/badge/Discord-7289da?style=for-the-badge&logo=discord&logoColor=white" alt="Discord" />
    </a> 
    <a href="https://ko-fi.com/community_scripts">
      <img src="https://img.shields.io/badge/Support-FF5F5F?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Donate" />
    </a>
    <a href="https://github.com/community-scripts/ProxmoxVE/blob/main/.github/CONTRIBUTOR_AND_GUIDES/CONTRIBUTING.md">
      <img src="https://img.shields.io/badge/Contribute-ff4785?style=for-the-badge&logo=git&logoColor=white" alt="Contribute" />
    </a> 
    <a href="https://github.com/community-scripts/ProxmoxVE/blob/main/.github/CONTRIBUTOR_AND_GUIDES/USER_SUBMITTED_GUIDES.md">
      <img src="https://img.shields.io/badge/Guides-0077b5?style=for-the-badge&logo=read-the-docs&logoColor=white" alt="Guides" />
    </a> 
    <a href="https://github.com/community-scripts/ProxmoxVE/blob/main/CHANGELOG.md">
      <img src="https://img.shields.io/badge/Changelog-6c5ce7?style=for-the-badge&logo=git&logoColor=white" alt="Changelog" />
    </a>
  </p>
</div>

---

## 🚀 Project Overview

**Proxmox VE Helper-Scripts** is a collection of tools to simplify the setup and management of Proxmox Virtual Environment (VE). Originally created by [tteck](https://github.com/tteck), these scripts are now continued by the community. Our goal is to preserve and expand upon tteck's work, providing an ongoing resource for Proxmox users worldwide.

---

## 📦 Features

- **Interactive Setup**: Choose between simple and advanced options for configuring VMs and LXC containers.
- **Customizable Configurations**: Advanced setup for fine-tuning your environment.
- **Seamless Integration**: Works seamlessly with Proxmox VE for a smooth experience.
- **Community-driven**: Actively maintained and improved by the Proxmox community.

---
## ✅ Requirements

Ensure your system meets the following prerequisites:

- **Proxmox VE version**: 8.x or higher
- **Linux**: Compatible with most distributions
- **Dependencies**: bash and curl should be installed.

---

## 🚀 Installation

To install the Proxmox Helper Scripts, follow these steps:

1. Visit the [Website](https://helper-scripts.com/).
2. Search for the desired script, e.g., **"Home Assistant OS VM"**.
3. Copy the provided **Bash command** from the **"How To Install"** section.
4. Open the Proxmox shell on your **main node** and paste the command.
5. Press enter to start the installation! 🚀

---

## ❤️ Community and Contributions

We appreciate any contributions to the project—whether it's bug reports, feature requests, documentation improvements, or spreading the word. Your involvement helps keep the project alive and sustainable.

## 💖 Donate to Support the Project
- **Ko-Fi for Community Edition**: [Donate to support this project](https://ko-fi.com/community_scripts) – Donations go towards maintaining the project, testing infrastructure, and charity (cancer research, hospice care). 30% of the funds will be donated to charity.

---

## 💬 Get Help

Join our community for support:

- **Discord**: Join our [Proxmox Helper Scripts Discord server](https://discord.gg/jsYVk5JBxq) for real-time support.
- **GitHub Discussions**: [Ask questions or report issues](https://github.com/community-scripts/ProxmoxVE/discussions).

## 🤝 Report a Bug or Feature Request

If you encounter any issues or have suggestions for improvement, file a new issue on our [GitHub issues page](https://github.com/community-scripts/ProxmoxVE/issues). You can also submit pull requests with solutions or enhancements!

---

## ⭐ Star History

<a href="https://star-history.com/#community-scripts/ProxmoxVE&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=community-scripts/ProxmoxVE&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=community-scripts/ProxmoxVE&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=community-scripts/ProxmoxVE&type=Date" />
 </picture>
</a>

## 📜 License

This project is licensed under the [MIT License](LICENSE).

</br>
</br>
<p align="center">
  <i style="font-size: smaller;"><b>Proxmox</b>® is a registered trademark of <a href="https://www.proxmox.com/en/about/company">Proxmox Server Solutions GmbH</a>.</i>
</p>

---

# Disclaimer - remz1337's fork
This fork aims to add support for Nvidia GPU. The scripts are not guaranteed to work with every hardware, but they have been tested with the following hardware:
- CPU: AMD Ryzen 5 3600
- Compute GPU (LXC): Nvidia T600
- Gaming GPU (VM): Nvidia RTX 2060
- Motherboard: Asrock B450M Pro4-F
- RAM: 4x8GB HyperX (non ECC)

# Extra scripts
Here's a shortlist of scripts/apps that did not get merged upstream (tteck) for various reasons:
- <a href="https://github.com/CollaboraOnline/online">Collabora Online</a>
- <a href="https://github.com/remz1337/Backup2Azure">Backup2Azure</a>
- <a href="https://github.com/blakeblackshear/frigate">Frigate</a> with Nvidia GPU passthrough (older cards such as Pascal may not work)
- <a href="https://github.com/claabs/epicgames-freegames-node">Epic Games free games</a>
- <a href="https://github.com/AnalogJ/scrutiny">Scrutiny</a>
- <a href="https://github.com/remz1337/SAQLottery">SAQLottery</a>
- Nvidia drivers support (detection/installation)
- Windows 11 Gaming VM

# Extra configurations
I have added some configuration options to streamline deployment of certain services in my environment. When building a container, I run an extra script to do that additional configuration. That script is `ct/post_create_lxc.sh`, which is called at the end of the `build_container()` function (in `build.func`). This can be used to:
- mount a shared folder by adding this configuration to the LXC:`mp0: /mnt/pve/share/public,mp=/mnt/pve/share`
- setup postfix service to run as a satellite, leveraging a single postfix LXC to send all emails
- passthrough a Nvidia GPU

Some of these configurations leverage settings that can be found in `/etc/pve-helper-scripts.conf`.

# Deploying services
To create a new LXC, run the following command directly on the host:
```
bash -c "$(wget -qLO - https://github.com/remz1337/ProxmoxVE/raw/remz/ct/<app>.sh)"
```
and replace `<app>` by the service you wish to deploy, eg. `.../remz/ct/frigate.sh)`

# Updating services
To update an existing LXC, run the following command directly on the host, where `<ID>` is the LXC ID (eg. 100, 101...) :
```
pct exec <ID> -- /usr/bin/update
```
Alternatively, you can update from within the LXC by running the same command used to create the machine but inside it (not on the host). Easiest way is to log in from the host using the `pct enter` command with the machine ID :
```
pct enter <ID>
bash -c "$(wget -qLO - https://github.com/remz1337/ProxmoxVE/raw/remz/ct/<app>.sh)"
```

# Installing and updating Nvidia drivers across host and containers
To install or update latest Nvidia drivers, run the following command directly on the host:
```
bash -c "$(wget -qLO - https://github.com/remz1337/ProxmoxVE/raw/remz/misc/nvidia-drivers-host.sh)"
```
# Donate to Support this fork
- **Ko-Fi for remz1337's fork**: [Donate to support this fork](https://ko-fi.com/remz1337)
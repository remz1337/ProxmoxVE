<div align="center">
  <p align="center">
    <a href="#">
      <img src="https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/images/logo.png" height="100px" />
    </a>
  </p>
</div>

<div style="border: 2px solid #d1d5db; padding: 20px; border-radius: 8px; background-color: #f9fafb;">
  <h2 align="center">Proxmox VE Helper-Scripts: A Community Legacy</h2>
  <p>Dear Community,</p>
  <p>In agreement with <a href="https://github.com/tteck">tteck</a> and <a href="https://github.com/community-scripts">Community-Scripts</a>, this project has now transitioned into a community-driven effort. We aim to continue his work, building on the foundation he laid to support Proxmox users worldwide. Tteck sadly <a href="https://github.com/community-scripts/ProxmoxVE/discussions/237">passed away in early November 2024</a>. This project will be a memorial for his incredible contribution to the community.</p>

<p align="center">
  <a href="https://helper-scripts.com">
    <img src="https://img.shields.io/badge/Website-4c9b3f?style=for-the-badge&logo=github&logoColor=white" alt="Website" />
  </a> 
  <a href="https://github.com/community-scripts/ProxmoxVE/blob/main/.github/CONTRIBUTING.md">
    <img src="https://img.shields.io/badge/Contribute-ff4785?style=for-the-badge&logo=git&logoColor=white" alt="Contribute" />
  </a> 
  <a href="https://github.com/community-scripts/ProxmoxVE/blob/main/USER_SUBMITTED_GUIDES.md">
    <img src="https://img.shields.io/badge/Guides-0077b5?style=for-the-badge&logo=read-the-docs&logoColor=white" alt="Guides" />
  </a> 
  <a href="https://discord.gg/UHrpNWGwkH">
    <img src="https://img.shields.io/badge/Discord-7289da?style=for-the-badge&logo=discord&logoColor=white" alt="Discord" />
  </a> 
  <a href="https://github.com/community-scripts/ProxmoxVE/blob/main/CHANGELOG.md">
    <img src="https://img.shields.io/badge/Changelog-6c5ce7?style=for-the-badge&logo=git&logoColor=white" alt="Changelog" />
  </a>
</p>

<hr>

## 🚀&nbsp; Introduction

**Proxmox VE Helper-Scripts** is a community-driven initiative that simplifies the setup of Proxmox Virtual Environment (VE). Originally created by [tteck](https://github.com/tteck), these scripts automate and streamline the process of creating and configuring Linux containers (LXC) and virtual machines (VMs) on Proxmox VE.

---

## 📦&nbsp; Features

- **Interactive Setup**: Select simple or advanced options for your VM or LXC container configurations.
- **Customizable Configuration**: Advanced setup allows you to fine-tune your environment.
- **Ease of Use**: Scripts automatically validate inputs to generate the final configuration.
- **Proxmox Integration**: Seamlessly integrates with Proxmox VE to provide a user-friendly experience.
- **Community-Driven**: This project is actively maintained and improved by the community.

<hr>

## 🚀&nbsp; Installation

To install the Proxmox Helper Scripts, simply follow these steps:

1. Open the [Website](https://helper-scripts.com/)
2. Search for the desired script, e.g. **"Home Assistant OS VM"**.
3. In the **"How To Install"** section, copy the provided **Bash command**.
4. Open the Proxmox shell on your **main node**.
5. Paste the command into the console, hit enter, and you are away! 🚀

For detailed instructions, check out our [official guides](https://github.com/remz1337/ProxmoxVE/blob/remz/USER_SUBMITTED_GUIDES.md).

---

## ❤️&nbsp; Community and Contributions

The Proxmox Helper Scripts project is community-driven, and we highly appreciate any contributions — whether it's through reporting bugs, suggesting features, improving documentation, or spreading the word. We are committed to maintaining transparency and sustainability in this open-source effort.

### 💖&nbsp; Donate to Support the Project

We offer two donation options to help maintain and grow this project:

- **Ko-Fi for tteck**: [Donate to tteck's wife](https://ko-fi.com/proxmoxhelperscripts) - All donations will go directly to Angie, wife of the founder of this project [who passed away in early November 2024](https://github.com/community-scripts/ProxmoxVE/discussions/237).
- **Ko-Fi for Community Edition**: [Donate to this project](https://ko-fi.com/community_scripts) -  All funds will go towards script maintenance infrastructure and server costs. **Our most immediate need is funding testing infrastructure**.  Your contributions help keep the project running. To honor tteck's legacy this project will also raise money for charity (cancer research, hospice care). Of the money donated to this project, 30% will be donated to charity. Income, expenditure and charitable donations will be disclosed annually in a transparent manner. 
- **Ko-Fi for remz1337 Edition**: [Donate to this fork](https://ko-fi.com/remz1337) -  All funds will go towards script maintenance infrastructure and server costs.

<hr>

## 💬&nbsp; Get Help

Have a question or ran into an issue? Join the conversation and get help from fellow community members:

- **Discord**: Join our [Proxmox Helper Scripts Discord server](https://discord.gg/UHrpNWGwkH) to chat with other users and get support.
- **GitHub Discussions**: [Ask questions or report issues](https://github.com/community-scripts/ProxmoxVE/discussions).

<hr>

## 🤝&nbsp; Found a bug or missing feature?

If you’ve encountered an issue or identified an area for improvement, please file a new issue on our [GitHub issues page](https://github.com/community-scripts/ProxmoxVE/issues). If you’ve already found a solution or improvement, feel free to submit a pull request! We’d love to review and merge your contributions.

<hr>

## ✅&nbsp; Requirements

To use the Proxmox VE Helper-Scripts, your system should meet the following requirements:

- **Proxmox VE version**: 8.x or higher
- **Linux**: Compatible with most distributions
- **Dependencies**: Ensure that your system has bash and curl installed.

<hr>

## 📜&nbsp; License

This project is licensed under the terms of the [MIT License](LICENSE).

## 📢&nbsp; Acknowledgments

This community project is a memorial to the memory of [tteck](https://github.com/tteck). His foundational work created a thriving Proxmox community. Tteck worked on this project right until the end, even while in hospice. We are dedicated to keeping his vision alive and expanding upon it with the continued support of this vibrant community.

Proxmox® is a registered trademark of [Proxmox Server Solutions GmbH](https://www.proxmox.com/en/about/company).

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
- setup postfix service to run as a satellite, leverage a single postfix LXC to send all emails
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

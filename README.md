<div align="center">
  <img src="https://raw.githubusercontent.com/remz1337/ProxmoxVE/remz/misc/images/logo-81x112.png" height="112px" alt="Proxmox VE Helper-Scripts Logo" />

  <h1>Proxmox VE Helper-Scripts</h1>
  <p><strong>One-command installations for services, containers, and VMs on Proxmox VE</strong><br/>
  A community project — built on the foundation of <a href="https://github.com/tteck">@tteck</a>'s original work</p>

  <p>
    <a href="https://community-scripts.org"><img src="https://img.shields.io/badge/Website-community--scripts.org-4c9b3f?style=flat-square" /></a>
    <a href="https://discord.gg/3AnUqsXnmK"><img src="https://img.shields.io/badge/Discord-Join_us-7289da?style=flat-square&logo=discord&logoColor=white" /></a>
    <a href="https://github.com/community-scripts/ProxmoxVE/stargazers"><img src="https://img.shields.io/github/stars/community-scripts/ProxmoxVE?style=flat-square&label=Stars&color=f5a623" /></a>
    <a href="https://github.com/community-scripts/ProxmoxVE/blob/main/CHANGELOG.md"><img src="https://img.shields.io/badge/Changelog-view-6c5ce7?style=flat-square" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" /></a>
  </p>
</div>

---

## What is this?

**Simplify your Proxmox VE setup with community-driven automation scripts.**

Install and configure popular self-hosted services with a single command — no manual package hunting, no config file archaeology. Paste a command into your Proxmox shell, answer a few prompts, and your container or VM is up and running.

The collection covers hundreds of services across categories like home automation, media servers, networking tools, databases, monitoring stacks, and more.

---

## Requirements

| Component      | Details                                          |
| -------------- | ------------------------------------------------ |
| **Proxmox VE** | Version 8.4, 9.0, 9.1, or 9.2                    |
| **Host OS**    | Proxmox VE (Debian-based)                        |
| **Access**     | Root shell access on the Proxmox host            |
| **Network**    | Internet connection required during installation |

---

## Getting Started

The fastest way to find and run scripts:

1. Go to **[community-scripts.org](https://community-scripts.org)**
2. Search for the service you want (e.g. "Home Assistant", "Nginx Proxy Manager", "Jellyfin")
3. Copy the one-line install command from the script page
4. Open your **Proxmox Shell** and paste it
5. Choose between **Default** or **Advanced** setup and follow the prompts

Each script page documents what the container includes, default resource allocation, and post-install notes.

---

## How Scripts Work

Every script follows the same pattern:

**Default mode** — Picks sensible resource defaults (CPU, RAM, storage) and asks only the minimum required questions. Most installs finish in under five minutes.

**Advanced mode** — Gives you full control over container settings, networking, storage backends, and application-level configuration before anything is installed.

After installation, each container ships with a **post-install helper** accessible from the Proxmox shell. It handles common tasks like:

- Applying updates to the installed service
- Changing application settings without manually editing config files
- Basic troubleshooting and log access

---

## What's Included

The repository covers a wide range of categories. A few examples:

| Category        | Examples                                            |
| --------------- | --------------------------------------------------- |
| Home Automation | Home Assistant, Zigbee2MQTT, ESPHome, Node-RED      |
| Media           | Jellyfin, Plex, Radarr, Sonarr, Immich              |
| Networking      | AdGuard Home, Nginx Proxy Manager, Pi-hole, Traefik |
| Monitoring      | Grafana, Prometheus, Uptime Kuma, Netdata           |
| Databases       | PostgreSQL, MariaDB, Redis, InfluxDB                |
| Security        | Vaultwarden, CrowdSec, Authentik                    |
| Dev & Tools     | Gitea, Portainer, VS Code Server, n8n               |

> Browse the full list at **[community-scripts.org/categories](https://community-scripts.org/categories)** — new scripts are added regularly.

---

## Contributing

This project runs on community contributions. Whether you want to write new scripts, improve existing ones, or just report a bug — every bit helps.

### Where to start

| I want to…                            | Go here                                                                                           |
| ------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Add a **new** script                  | [ProxmoxVED](https://github.com/community-scripts/ProxmoxVED) — new scripts are tested here first |
| Fix or improve an **existing** script | [Contributing Guidelines](CONTRIBUTING.md) — open a PR in this repo                               |
| Report a bug or broken script         | [Issues](https://github.com/community-scripts/ProxmoxVE/issues)                                   |
| Request a new script or feature       | [Discussions](https://github.com/community-scripts/ProxmoxVE/discussions)                         |
| Report a security vulnerability       | [Security Policy](SECURITY.md)                                                                    |
| Get help or chat with other users     | [Discord](https://discord.gg/3AnUqsXnmK)                                                          |

### Before you open a PR

- **New scripts go to [ProxmoxVED](https://github.com/community-scripts/ProxmoxVED), not here.** PRs with new scripts opened directly against this repo will be closed.
- Bug fixes and improvements to existing scripts belong in this repo — read the [Contributing Guidelines](CONTRIBUTING.md) first.
- Keep PRs focused. One fix or feature per PR.
- Document what your script installs and any non-obvious decisions in the corresponding JSON metadata file.

---

## Core Team

<table align="center">
  <tr>
    <td align="center">
      <a href="https://github.com/MickLesk">
        <img src="https://github.com/MickLesk.png" width="80" height="80" style="border-radius:50%" alt="MickLesk" /><br/>
        <sub><b>MickLesk</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/michelroegl-brunner">
        <img src="https://github.com/michelroegl-brunner.png" width="80" height="80" style="border-radius:50%" alt="michelroegl-brunner" /><br/>
        <sub><b>michelroegl-brunner</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/BramSuurdje">
        <img src="https://github.com/BramSuurdje.png" width="80" height="80" style="border-radius:50%" alt="BramSuurdje" /><br/>
        <sub><b>BramSuurdje</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/CrazyWolf13">
        <img src="https://github.com/CrazyWolf13.png" width="80" height="80" style="border-radius:50%" alt="CrazyWolf13" /><br/>
        <sub><b>CrazyWolf13</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/tremor021">
        <img src="https://github.com/tremor021.png" width="80" height="80" style="border-radius:50%" alt="tremor021" /><br/>
        <sub><b>tremor021</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/vhsdream">
        <img src="https://github.com/vhsdream.png" width="80" height="80" style="border-radius:50%" alt="vhsdream" /><br/>
        <sub><b>vhsdream</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/asylumexp">
        <img src="https://github.com/asylumexp.png" width="80" height="80" style="border-radius:50%" alt="asylumexp" /><br/>
        <sub><b>asylumexp</b></sub>
      </a>
    </td>
  </tr>
</table>

---

## Project Activity

<p align="center">
  <img
    src="https://repobeats.axiom.co/api/embed/57edde03e00f88d739bdb5b844ff7d07dd079375.svg"
    alt="Repository activity"
    width="700"
  />
</p>

<p align="center">
  <a href="https://star-history.com/#community-scripts/ProxmoxVE&Date">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=community-scripts/ProxmoxVE&type=Date&theme=dark" />
      <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=community-scripts/ProxmoxVE&type=Date" />
      <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=community-scripts/ProxmoxVE&type=Date" width="700" />
    </picture>
  </a>
</p>

---

## Support the Project

This project is maintained by volunteers. All infrastructure costs come out of pocket, and the work is done in people's spare time.

**30% of all donations are forwarded directly to cancer research and hospice care** — a cause that was important to tteck.

<div align="center">
  <a href="https://ko-fi.com/community_scripts">
    <img src="https://img.shields.io/badge/Support_on_Ko--fi-FF5F5F?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Support on Ko-fi" />
  </a>
  &nbsp;
  <a href="https://community-scripts.org/donate">
    <img src="https://img.shields.io/badge/Donate-community--scripts.org%2Fdonate-4c9b3f?style=for-the-badge" alt="Donate via community-scripts.org" />
  </a>
</div>

---

## License

This project is licensed under the [MIT License](LICENSE) — free to use, modify, and redistribute for personal and commercial purposes.

See the full license text in [LICENSE](LICENSE).

---

<div align="center">
  <sub>Built on the foundation of <a href="https://github.com/tteck">tteck</a>'s original work · <a href="https://github.com/tteck/Proxmox">Original Repository</a></sub><br/>
  <sub>Maintained and expanded by the community · In memory of tteck</sub><br/>
  <sub><i>Proxmox® is a registered trademark of <a href="https://www.proxmox.com/en/about/company">Proxmox Server Solutions GmbH</a></i></sub>
</div>

---

# Disclaimer - remz1337's fork
This fork aims to add support for Nvidia GPU. The scripts are not guaranteed to work with every hardware, but they have been tested with the following hardware:
- CPU: AMD Ryzen 5 3600
- Compute GPU (LXC): Nvidia T600
- Gaming GPU (VM): Nvidia RTX 2060
- Motherboard: Asrock B450M Pro4-F
- RAM: 4x8GB HyperX (non ECC)

## Diagnostics API
All diagnostic functions have been disabled.

# Extra scripts
Here's a shortlist of scripts/apps that did not get merged upstream (tteck) for various reasons:
- <a href="https://github.com/CollaboraOnline/online">Collabora Online</a>
- <a href="https://github.com/remz1337/Backup2Azure">Backup2Azure</a>
- <a href="https://github.com/blakeblackshear/frigate">Frigate</a> with Nvidia GPU passthrough (older cards such as Pascal may not work)
- <a href="https://github.com/claabs/epicgames-freegames-node">Epic Games free games</a>
- <a href="https://github.com/AnalogJ/scrutiny">Scrutiny</a>
- <a href="https://github.com/remz1337/SAQLottery">SAQLottery</a>
- <a href="https://gitea.com/gitea/act">Gitea Act Runner (CI/CD)</a>
- <a href="https://github.com/stalwartlabs/stalwart">Stalwart</a>
- <a href="https://github.com/getnora-io/nora">Nora</a>
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

# Zero Trust Homelab Gateway & DNS Sinkhole 🛡️

![Debian](https://img.shields.io/badge/Debian-OS-A81D33?style=flat-square&logo=debian)
![Docker](https://img.shields.io/badge/Docker-IaC-2496ED?style=flat-square&logo=docker)
![Tailscale](https://img.shields.io/badge/Tailscale-ZTNA-black?style=flat-square)
![WireGuard](https://img.shields.io/badge/WireGuard-VPN-881798?style=flat-square&logo=wireguard)
![AdGuard](https://img.shields.io/badge/AdGuard_Home-DNS_Sinkhole-68BC71?style=flat-square&logo=adguard)

This project documents the transformation of legacy hardware into a headless, highly efficient **Zero Trust Network Access** gateway and network-wide ad blocker. The goal was to build a secure, remotely accessible home infrastructure utilizing containerization and modern VPN protocols without opening any inbound ports on the edge router.

## 🛠️ Technologies
* **Operating System:** Debian Linux.
* **Containerization:** Docker & Docker Compose.
* **Network Security:** Tailscale.
* **DNS Sinkholing:** AdGurad Home.
* **Access Control:** Identity-based authentication.

## ✨ Features

### 1. Network-wide Ad & Tracker Blocking
Deployed **AdGuard Home** within a Docker container to intercept and filter DNS requests. Integrated aggressive, community-maintained blocklists to actively prevent telemetry, malware and ads at the network level.

### 2. Zero Trust Mesh VPN
Configured the server as a **Tailscale Exit Node**. This allows mobile devices (on public Wi-Fi or LTE) to establish an encrypted WireGurad tunnel directly to the server, masking their public IP and forcing all traffic through the AdGurad DNS filter.

### 3. Advanced Tailscale Integration
To fully leverage the Zero Trust architecture, I implemented several advanced networking features:
* **Tailscale SSH:** Eliminated the need for traditional SSH keys and passwords. Access to the server's terminal is now authenticated via the identiry provider and authorized exclusively through the Tailscale mesh network.
* **Subnet Routing:** Configured the Debian server to act as a gateway to the local physical network, allowing secure remote access to non-Tailscale IoT devices (e.g., printers, smart home hubs).
* **Taildrop:** Enabled encrypted, peer-to-peer file transfers across all connected devices in the mesh network.

## ⚙️ The Process

### Phase 1: Headless Provisioning & Infrastructure as Code
The server was built on a minimal Debian installation to ensure low overhead. After disabling sleep states for lid-closure, I deployed the Docker engine. To ensure reproducibility and easy migration, the entire AdGurad Home environment was codified using a 'docker-compose.yml' file with persistent volume mapping.

### Phase 2: ZTNA & MagicDNS Integration
After deploying Tailscale on the host network layer, I configured IP forwarding ('net.ipv4.ip_forward') in the Linux kernel to allow the servwe to route packets for other devices. Finally, I configured Tailscale's MagicDNS to globally override DNS settings, ensuring that any device joining the mesh network automatically queries the Dockerized AdGurad container for name resolution.

## 📊 Proof of Concept / Testing

* **Remote Ad-Blocking:** Connected a smartphone via LTE to the Tailscale network. Verified that ads were successfully dropped by monitoring the live Query Log in the AdGuard Home Dashboard.
* **Passwordless SSH:** Attempted to access the server via port 22 from an unauthorized IP (Connection Refused). Then, successfully established an SSH session using the 'tailscale ssh' command, proving identity-based access control.


## 💡 What I Learned
* **Docker Networking:** Gained practical experience mapping container ports to the host interface and managing persistent storage volumes for stateful applications.
* **DNS Limitaion::** Learned that DNS sinkholing effectively block domain-based ads but cannot filter elements served from the same domain as the primary content, highlighting the need for a Defense in Depth approach.
* **Zero Trust Paradigm:** Transitioned from the traditional "castle-and-moat" security model (relying on edge firewalls and port forwarding) to an identiy-first perimeter, understanding how Tailscale utilizes NAT traversal to establish direct P2P connections.

## How to run the Project
1. Clone this repository to your server.
2. Navigate to the project directory containing the 'docker-compose.yml' file.
3. Deploy the container in detached mode:
```bash
docker compose up -d
```
4. Access the AdGurad Home WebGui on 'http://[YOUR_SERVER_IP]:3000' to complete the initial setup.
5. In your Tailscale Admin Console, set your server's Tailscale IP as the Globel Nameserver and enable "Override local DNS".

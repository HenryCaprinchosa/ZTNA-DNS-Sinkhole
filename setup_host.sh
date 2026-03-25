#!/bin/bash
# Host provisioning script for Zero Trust Gateway

echo "1. Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "2. Enabling IP Forwarding for Exit Node / Subnet Routing..."
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

echo "3. Starting Tailscale (Please authenticate in browser)..."
sudo tailscale up --advertise-exit-node --ssh

echo "Host network layer configured successfully."
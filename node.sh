#!/bin/bash

# Turn off swap
sudo swapoff -a

# Comment out all swap entries in /etc/fstab to disable them permanently
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load necessary kernel modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Activate modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Set sysctl settings for Kubernetes networking
sudo tee /etc/sysctl.d/kubernetes.conf <<EOT
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOT

# Apply sysctl settings without reboot
sudo sysctl --system

# Install prerequisites
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package list
sudo apt update

# Install containerd
sudo apt install -y containerd.io

# Configure containerd and reload systemd daemon
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# Add Kubernetes GPG key and repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package list
sudo apt update

# Install Kubernetes components
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


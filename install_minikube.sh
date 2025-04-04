#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Install minikube .deb package
echo "\n${bold}Install minikube .deb package${normal}\n"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

# Install Docker
echo "\n${bold}Install Docker${normal}\n"
chmod +x install_docker_debian.sh
./install_docker_debian.sh

# Start minikube
echo "\n${bold}Start minikube${normal}\n"
minikube start

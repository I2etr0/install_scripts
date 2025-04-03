#!/bin/bash

# Add var for setting bolt text
bold=$(tput bold)

# Set up the repository
echo "${bold} Set up the repository ${bold}"
sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# remove all old version Docker
echo "${bold} Remove all old version Docker ${bold}"
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# To install the latest version, run:
echo "${bold} Install the latest version ${bold}"
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker Engine:
echo "${bold}  Enable Docker Engine ${bold}"
sudo systemctl enable --now docker

# Start Docker Engine:
echo "${bold} Start Docker Engine ${bold}"
sudo systemctl start docker

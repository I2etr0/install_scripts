#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Update gutlab-runner repo:
echo "${bold}Update gutlab-runner repo${normal}"
sleep 2
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

# Install runner
echo "${bold}Install gitlab-runner${normal}"
sleep 2
sudo apt install -y gitlab-runner
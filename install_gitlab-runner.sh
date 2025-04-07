#!/bin/bash

# Update gutlab-runner repo:
echo "Update gutlab-runner repo"
sleep 2
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

# Install runner
echo "Install gitlab-runner"
sleep 2
sudo apt install -y gitlab-runner
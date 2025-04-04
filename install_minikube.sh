#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Install minikube .deb package
echo "${bold}Install minikube .deb package${normal}"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

# Start minikube
echo "${bold}Start minikube${normal}"
minikube start

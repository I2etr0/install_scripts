#!/bin/bash

# Add rhel repo:
echo "${bold} Add rhel repo ${bold}" 
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Update system:
echo "${bold} Update system ${bold}" 
sudo yum upgrade

# Add required dependencies for the jenkins package
echo "${bold} Add required dependencies for the jenkins package ${bold}" 
sudo yum install -y fontconfig java-17-openjdk
sudo yum install -y jenkins
sudo systemctl daemon-reload

# Enable Jenkin's services:
echo "${bold} Enable Jenkin's services ${bold}"
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

#!/bin/bash

# ------------------------------------------------------------------------------
# User Data Script for EC2 Instance Bootstrap
# This script runs automatically on instance launch.
# It installs Docker and adds the default 'ubuntu' user to the Docker group.
# ------------------------------------------------------------------------------

# Update package lists and install prerequisites
sudo apt-get update -y && 
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common &&

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&

# Set up the Docker repository
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" &&

# Update again and install Docker
sudo apt-get update -y && 
sudo apt-get install docker-ce docker-ce-cli containerd.io -y &&

# Add the 'ubuntu' user to the Docker group to allow non-root Docker use
sudo usermod -aG docker ubuntu

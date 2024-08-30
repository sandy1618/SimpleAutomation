#!/bin/bash

# Update the package list
sudo apt update

# Install prerequisites
sudo apt install -y build-essential dkms

# Add the NVIDIA package repository
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt update

# Install the NVIDIA driver
sudo apt install -y nvidia-driver-470

# Reboot to load the NVIDIA driver
echo "Rebooting system to load the NVIDIA driver..."
sudo reboot
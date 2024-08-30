#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Check if Snap is installed
if ! command -v snap &> /dev/null; then
    echo "Snap package manager is not installed. Installing Snap..."
    sudo apt install snapd -y
    sudo systemctl start snapd
    sudo systemctl enable snapd
    sudo ln -s /var/lib/snapd/snap /snap
    echo "Snap installed successfully."
else
    echo "Snap package manager is already installed."
fi

# Install VS Code through Snap
echo "Attempting to install VS Code via Snap..."
if sudo snap install code --classic; then
    echo "VS Code installed successfully via Snap."
else
    echo "Failed to install VS Code via Snap. Attempting installation via apt..."
    
    # Fallback to installing VS Code via apt
    sudo apt install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install code -y
fi

# Install essential software
echo "Installing essential software..."
sudo apt install curl -y
sudo apt install build-essential -y
sudo apt install htop -y
sudo apt install tree -y
sudo apt install vim -y

# Clean up
echo "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "Setup complete! Your system is ready."
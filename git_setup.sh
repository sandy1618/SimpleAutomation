#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install Git
echo "Installing Git..."
sudo apt install git -y

# Create directory inside Documents and clone repositories
REPO_DIR=~/Documents/Repository

if [ -d "$REPO_DIR" ]; then
    echo "Directory $REPO_DIR already exists. Changing to $REPO_DIR..."
else
    echo "Creating repository directory at $REPO_DIR..."
    mkdir -p $REPO_DIR
fi

echo "Cloning SimpleAutomation repository into $REPO_DIR..."
git clone https://github.com/sandy1618/SimpleAutomation.git $REPO_DIR/SimpleAutomation

# Make all .sh files in the SimpleAutomation repository executable
echo "Making all .sh files in $REPO_DIR/SimpleAutomation executable..."
find $REPO_DIR/SimpleAutomation -type f -name "*.sh" -exec chmod +x {} \;

# Clean up
echo "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "Setup complete! Your system is ready with Git."
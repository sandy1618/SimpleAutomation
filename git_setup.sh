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
    echo "Directory $REPO_DIR already exists."
else
    echo "Creating repository directory at $REPO_DIR..."
    mkdir -p $REPO_DIR
fi

# Define the repository URL and the target directory
REPO_URL="https://github.com/sandy1618/SimpleAutomation.git"
TARGET_DIR="$REPO_DIR/SimpleAutomation"

# Check if the repository already exists
if [ -d "$TARGET_DIR" ]; then
    echo "Repository SimpleAutomation already exists at $TARGET_DIR. Skipping clone."
else
    echo "Cloning SimpleAutomation repository into $REPO_DIR..."
    git clone $REPO_URL $TARGET_DIR
fi

# Make all .sh files in the SimpleAutomation repository executable
echo "Making all .sh files in $TARGET_DIR executable..."
find $TARGET_DIR -type f -name "*.sh" -exec chmod +x {} \;

# Clean up
echo "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "Setup complete! Your system is ready with Git."
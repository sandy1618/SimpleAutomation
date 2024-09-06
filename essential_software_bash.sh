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

# Function to install software via Snap with fallback to another method
install_with_fallback() {
    local app_name=$1
    local snap_name=$2
    local fallback_function=$3
    local desktop_file_name=$4

    echo "Attempting to install $app_name via Snap..."
    if sudo snap install $snap_name; then
        echo "$app_name installed successfully via Snap."
    else
        echo "Failed to install $app_name via Snap. Falling back to another method..."
        $fallback_function
    fi

    # Add the application to the GNOME Dock favorites
    if [ -n "$desktop_file_name" ]; then
        gnome_favorites=$(gsettings get org.gnome.shell favorite-apps)
        if [[ $gnome_favorites != *"$desktop_file_name"* ]]; then
            echo "Adding $app_name to the GNOME Dock favorites..."
            gsettings set org.gnome.shell favorite-apps "$(echo $gnome_favorites | sed "s/]$/, '$desktop_file_name.desktop']/")"
        else
            echo "$app_name is already in the GNOME Dock favorites."
        fi
    fi
}

# Fallback function to install VS Code via apt
install_vscode_apt() {
    sudo apt install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install code -y
}

# Fallback function to install Brave Browser via apt
install_brave_apt() {
    sudo apt install apt-transport-https curl -y
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser -y
}

# Fallback function to install Google Chrome via .deb package
install_chrome_deb() {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb
}

# Fallback function to install Slack via .deb package
install_slack_deb() {
    wget https://downloads.slack-edge.com/releases/linux/4.29.149/prod/x64/slack-desktop-4.29.149-amd64.deb
    sudo apt install ./slack-desktop-*.deb -y
    rm slack-desktop-*.deb
}


# Install VS Code with fallback and add to Dock
install_with_fallback "VS Code" "code --classic" install_vscode_apt "code"

REPO_DIR=~/Documents/Repository/SimpleAutomation
# Copy VS Code settings and keybindings
echo "Copying VS Code settings and keybindings..."
mkdir -p ~/.config/Code/User/
cp $REPO_DIR/vscode_backup/settings.json ~/.config/Code/User/settings.json
cp $REPO_DIR/vscode_backup/keybindings.json ~/.config/Code/User/keybindings.json
cat $REPO_DIR/vscode_backup/extension.txt | xargs -L 1 code --install-extension

# Install Brave Browser with fallback and add to Dock
install_with_fallback "Brave Browser" "brave" install_brave_apt "brave-browser"

# Check if Google Chrome is installed, if not, install it and add to Dock
if ! command -v google-chrome &> /dev/null; then
    echo "Google Chrome is not installed. Installing..."
    install_with_fallback "Google Chrome Browser" "" install_chrome_deb "google-chrome"
else
    echo "Google Chrome is already installed."
fi

# Install Slack with fallback and add to Dock
if ! command -v slack &> /dev/null; then
    echo "Slack is not installed. Installing..."
    install_with_fallback "Slack" "slack" install_slack_deb "slack"
else
    echo "Slack is already installed."
fi


# Install Cursor Editor through Snap (no fallback needed as there's no alternative installation method)
echo "Installing Cursor Editor..."
sudo snap install cursor-editor

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
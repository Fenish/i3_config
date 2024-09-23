#!/bin/bash

APPLICATIONS=("i3-wm" "i3status" "i3lock" "xss-lock" "xorg-server" "xorg-apps" "xorg-xinit" "curl" "wget" "zsh")

COLOR_YELLOW="\e[33m"
COLOR_RED="\e[31m"
COLOR_BLUE="\e[34m"
COLOR_MAGENTA="\e[35m"
COLOR_GREEN="\e[32m"
COLOR_RESET="\e[0m"

# Check if script is run as non root
if [ "$EUID" -eq 0 ]; then
    echo "Please run as a non-root user."
    exit
fi

print() {
    local color="$1"
    shift
    echo -e "${color}$@${COLOR_RESET}"
}

# Install yay
# ============================================================================

check_yay() {
    if command -v yay &> /dev/null; then
        print "$COLOR_YELLOW" "Yay is already installed. Skipping..."
        return 0
    else
        return 1
    fi
}

install_yay() {
    echo "Cloning yay repository..."
    git clone https://aur.archlinux.org/yay.git

    cd yay || { echo "Failed to change directory to yay."; exit 1; }

    echo "Building and installing yay..."
    makepkg -si

    cd ..
    echo "Cleaning up..."
    rm -rf yay

    echo "yay has been successfully installed."

}

if ! check_yay; then
    install_yay
fi

print "$COLOR_BLUE" "\nInstalling modules"
# yay -S --noconfirm "${APPLICATIONS[@]}" > /dev/null 2>&1
print "$COLOR_GREEN" "All modules installed successfully.".

print "$COLOR_BLUE" "Configuring oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print "$COLOR_BLUE" "Configuring i3..."
cp -r i3 ~/.config
cp -r i3status ~/.config

print "$COLOR_BLUE" "Installing starship..."
curl -sS https://starship.rs/install.sh | sh

print "$COLOR_BLUE" "Installing zsh plugins.."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone git@github.com:zdharma-continuum/history-search-multi-word.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-search-multi-word

print "$COLOR_BLUE" "Configuring zsh"
cp .zshrc ~/.zshrc

print "$COLOR_BLUE" "Settings zsh to default terminal"
chsh -s $(which zsh)

echo "exec i3" >> ~/.xinitrc
#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to ask for confirmation
confirm_install() {
    local tool=$1
    local description=$2
    
    echo -e "\n${BLUE}==== $tool ====${NC}"
    echo -e "${YELLOW}Description:${NC} $description"
    
    while true; do
        read -p "Do you want to install $tool? (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) echo -e "${YELLOW}Skipping $tool...${NC}"; return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Check if Homebrew is installed
check_brew() {
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Homebrew is not installed. Installing Homebrew first...${NC}"
        if confirm_install "Homebrew" "The missing package manager for macOS"; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo -e "${GREEN}Homebrew installed successfully!${NC}"
        else
            echo -e "${RED}Homebrew is required for most installations. Exiting...${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Homebrew is already installed.${NC}"
    fi
}

# Main function
main() {
    echo -e "${BLUE}======================================${NC}"
    echo -e "${GREEN}Mac Basic Utilities Installer Script${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo -e "${YELLOW}This script will help you install basic utilities on your Mac.${NC}"
    echo -e "${YELLOW}You will be prompted before each installation.${NC}"
    echo ""
    
    # Check and install Homebrew first
    check_brew
    
    # Update Homebrew
    echo -e "\n${YELLOW}Updating Homebrew...${NC}"
    brew update
    
    # List of utilities with descriptions
    declare -A utilities
    utilities=(
        ["git"]="Distributed version control system"
        ["wget"]="Internet file retriever"
        ["curl"]="Command line tool for transferring data with URL syntax"
        ["htop"]="Interactive process viewer (better than top)"
        ["tree"]="Display directories as trees"
        ["jq"]="Lightweight and flexible command-line JSON processor"
        ["tldr"]="Simplified and community-driven man pages"
        ["python"]="Programming language"
        ["node"]="JavaScript runtime"
        ["vim"]="Highly configurable text editor"
        ["rectangle"]="Move and resize windows using keyboard shortcuts"
        ["iterm2"]="Terminal emulator for macOS"
        ["visual-studio-code"]="Code editor"
        ["alfred"]="Productivity app for macOS"
        ["the-unarchiver"]="Data decompression utility"
        ["spotify"]="Music streaming service"
        ["google-chrome"]="Web browser"
        ["firefox"]="Web browser"
    )
    
    # Install command-line utilities
    for tool in git wget curl htop tree jq tldr python node vim; do
        if confirm_install "$tool" "${utilities[$tool]}"; then
            echo -e "${YELLOW}Installing $tool...${NC}"
            brew install "$tool"
            echo -e "${GREEN}$tool installed successfully!${NC}"
        fi
    done
    
    # Install GUI applications
    for app in rectangle iterm2 visual-studio-code alfred the-unarchiver spotify google-chrome firefox; do
        if confirm_install "$app" "${utilities[$app]}"; then
            echo -e "${YELLOW}Installing $app...${NC}"
            brew install --cask "$app"
            echo -e "${GREEN}$app installed successfully!${NC}"
        fi
    done
    
    echo -e "\n${GREEN}Installation process completed!${NC}"
    echo -e "${YELLOW}Remember to restart your terminal or run 'source ~/.zshrc' or 'source ~/.bash_profile' to apply changes.${NC}"
}

# Run the main function
main
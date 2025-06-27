#!/bin/bash

# Mac Setup - Homebrew Installation Script
# This script installs Homebrew and essential command line tools

set -e

echo "🍺 Installing Homebrew and essential tools..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Homebrew is already installed
if command -v brew &> /dev/null; then
    print_status "Homebrew is already installed. Updating..."
    brew update
else
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install essential command line tools
print_status "Installing essential command line tools..."

# Core utilities
brew install \
    coreutils \
    findutils \
    gnu-tar \
    gnu-sed \
    gawk \
    gnutls \
    grep \
    wget \
    curl \
    git \
    tree \
    htop \
    jq \
    yq \
    bat \
    fd \
    ripgrep \
    fzf \
    tmux \
    neovim \
    zsh-completions \
    zsh-syntax-highlighting \
    zsh-autosuggestions

# Development tools
brew install \
    python \
    node \
    go \
    rust \
    ruby \
    php \
    java \
    maven \
    gradle \
    docker \
    docker-compose \
    kubectl \
    helm \
    terraform \
    awscli \
    gcloud \
    azure-cli

# Database tools
brew install \
    postgresql \
    mysql \
    redis \
    mongodb/brew/mongodb-community

# Network tools
brew install \
    nmap \
    wireshark \
    httpie \
    mtr \
    speedtest-cli

# Media tools
brew install \
    ffmpeg \
    imagemagick \
    exiftool \
    youtube-dl

# Security tools
brew install \
    openssl \
    gpg \
    sqlmap

# Utility tools
brew install \
    mas \
    the_silver_searcher \
    tldr \
    cheat \
    asdf \
    direnv \
    starship

print_status "Installing Homebrew Cask applications..."
# Install essential GUI applications via Cask
brew install --cask \
    google-chrome \
    firefox \
    visual-studio-code \
    iterm2 \
    rectangle \
    alfred \
    spectacle \
    caffeine \
    appcleaner \
    the-unarchiver \
    vlc \
    spotify \
    discord \
    slack \
    zoom \
    notion \
    obsidian \
    postman \
    docker \
    tableplus \
    sequel-pro \
    mongodb-compass \
    android-studio \
    figma \
    sketch

print_status "Installing Mac App Store applications..."
# Install Mac App Store applications (curated list)
mas install 409183694   # Keynote
mas install 409201541   # Pages
mas install 409203825   # Numbers
mas install 408981434   # iMovie
mas install 408981381   # GarageBand
mas install 1142151959  # Bear
mas install 1176895641  # Spark
mas install 1284863847  # Unsplash Wallpapers
mas install 1451685025  # WireGuard
mas install 1482454543  # Twitter
mas install 1518036000  # Loom
mas install 1558340332  # Reeder
mas install 1569813296  # 1Password
mas install 1601151613  # Baking Soda
mas install 1607635845  # Velja
mas install 1611378436  # Pure Paste
mas install 1615988943  # Pastebot
mas install 1626172644  # PDF Squeezer
mas install 1636709992  # DevToys
mas install 1640942130  # PDF Expert
mas install 1659652954  # Arc
mas install 1661733224  # Maccy
mas install 1671045996  # WaterMinder

print_status "Setting up Homebrew services..."
# Start essential services
brew services start postgresql
brew services start mysql
brew services start redis
brew services start mongodb/brew/mongodb-community

print_status "Cleaning up Homebrew..."
# Clean up Homebrew
brew cleanup

print_status "✅ Homebrew installation complete!"
print_status "Next steps:"
print_status "1. Run: ./scripts/configure-shell.sh"
print_status "2. Run: ./scripts/setup-dev.sh"
print_status "3. Configure your applications manually" 
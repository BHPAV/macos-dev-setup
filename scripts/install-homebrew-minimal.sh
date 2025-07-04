#!/bin/bash

# Mac Setup - Minimal Homebrew Installation Script
# This script installs Homebrew for our minimal development environment

set -e

echo "🍺 Installing Homebrew..."

# Colors for output
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

print_status "Installing from Brewfile..."

# Check for existing Docker installation
if [[ -d "/Applications/Docker.app" ]] && ! brew list --cask docker &> /dev/null; then
    print_warning "Docker.app already exists. Skipping Docker cask installation."
    print_warning "To manage Docker with Homebrew, remove existing Docker.app first."
fi

# Install everything from our minimal Brewfile
print_status "Running brew bundle..."
if ! brew bundle --file=scripts/Brewfile; then
    print_warning "Some packages failed to install. Check the output above."
    print_warning "Run './scripts/verify-installation.sh' to see what's missing."
fi

print_status "Cleaning up..."
brew cleanup

print_status "✅ Homebrew installation complete!"
print_status "Next steps:"
print_status "1. Launch and configure installed applications"
print_status "2. Set up development environment configurations" 
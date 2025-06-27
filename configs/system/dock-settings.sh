#!/bin/bash

# macOS Dock Configuration Script
# This script configures the Dock with preferred settings

echo "🍎 Configuring macOS Dock..."

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Dock position (bottom, left, right)
print_status "Setting Dock position to bottom..."
defaults write com.apple.dock orientation -string "bottom"

# Dock size
print_status "Setting Dock size..."
defaults write com.apple.dock tilesize -int 48

# Dock magnification
print_status "Enabling Dock magnification..."
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

# Dock auto-hide
print_status "Enabling Dock auto-hide..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0.2
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Show recent applications
print_status "Enabling recent applications in Dock..."
defaults write com.apple.dock show-recents -bool true

# Minimize windows into application icon
print_status "Setting minimize effect..."
defaults write com.apple.dock minimize-to-application -bool true

# Show indicators for open applications
print_status "Enabling open application indicators..."
defaults write com.apple.dock show-process-indicators -bool true

# Animate opening applications
print_status "Enabling application opening animation..."
defaults write com.apple.dock launchanim -bool true

# Show only open applications
print_status "Setting Dock to show only open applications..."
defaults write com.apple.dock static-only -bool false

# Disable Dashboard
print_status "Disabling Dashboard..."
defaults write com.apple.dashboard mcx-disabled -bool true

# Disable Mission Control
print_status "Disabling Mission Control..."
defaults write com.apple.dock mcx-expose-disabled -bool false

# Restart Dock to apply changes
print_status "Restarting Dock to apply changes..."
killall Dock

print_status "✅ Dock configuration complete!" 
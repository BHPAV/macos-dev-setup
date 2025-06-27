#!/bin/bash

# macOS Security Configuration Script
# This script configures security settings for macOS

echo "🔒 Configuring macOS Security Settings..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Enable FileVault
print_status "Enabling FileVault disk encryption..."
sudo fdesetup enable

# Enable Firewall
print_status "Enabling Firewall..."
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Configure Gatekeeper
print_status "Configuring Gatekeeper..."
sudo spctl --master-enable
sudo spctl --add --label 'Approved' /Applications

# Enable automatic updates
print_status "Enabling automatic updates..."
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true

# Configure login window
print_status "Configuring login window..."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo -string "HostName"
sudo defaults write /Library/Preferences/com.apple.loginwindow ShowInputMenu -bool true
sudo defaults write /Library/Preferences/com.apple.loginwindow DisableConsoleAccess -bool true

# Configure screen saver
print_status "Configuring screen saver..."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Configure sleep settings
print_status "Configuring sleep settings..."
sudo pmset -a sleep 0
sudo pmset -a hibernatemode 0
sudo pmset -a powernap 0

# Disable guest account
print_status "Disabling guest account..."
sudo sysadminctl -guestAccount off

# Configure privacy settings
print_status "Configuring privacy settings..."

# Disable location services
sudo defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 0

# Disable analytics
defaults write com.apple.AnalyticsClient AnalyticsEnabled -bool false

# Disable crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable diagnostic reports
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

# Configure Safari privacy
print_status "Configuring Safari privacy settings..."
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Configure Chrome privacy
print_status "Configuring Chrome privacy settings..."
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome CanaryDisablePrintPreview -bool true

# Configure Firefox privacy
print_status "Configuring Firefox privacy settings..."
defaults write org.mozilla.firefox DisablePrintPreview -bool true

print_status "✅ Security configuration complete!"
print_warning "Please review and customize these settings as needed for your environment." 
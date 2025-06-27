#!/bin/bash

# Mac Setup - GitHub Configuration Script
# This script sets up SSH keys and configures GitHub CLI

set -e

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

# Create .ssh directory if it doesn't exist
print_status "Setting up SSH directory..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH key
print_status "Generating SSH key..."
read -p "Enter your GitHub email address: " github_email
ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/github_ed25519 -N ""

# Add SSH key to ssh-agent
print_status "Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Create/update SSH config
print_status "Configuring SSH..."
cat > ~/.ssh/config << EOL
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github_ed25519
EOL

chmod 600 ~/.ssh/config

# Add SSH key to keychain and ssh-agent
ssh-add --apple-use-keychain ~/.ssh/github_ed25519

# Display the public key
print_status "Your SSH public key (add this to GitHub):"
cat ~/.ssh/github_ed25519.pub

print_warning "Please copy the above public key and add it to GitHub:"
print_warning "1. Go to: https://github.com/settings/keys"
print_warning "2. Click 'New SSH key'"
print_warning "3. Paste the key and give it a title (e.g., 'MacBook Pro')"

# Configure GitHub CLI if installed
if command -v gh &> /dev/null; then
    print_status "Configuring GitHub CLI..."
    print_warning "You'll be prompted to authenticate with GitHub..."
    gh auth login -p ssh -h github.com
else
    print_warning "GitHub CLI (gh) not found. Install it with: brew install gh"
fi

print_status "✅ GitHub setup complete!"
print_warning "To verify SSH connection, run: ssh -T git@github.com" 
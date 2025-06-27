#!/bin/bash

# Mac Setup - Git Configuration Script
# This script sets up Git with best practices and secure defaults

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

# Prompt for user information
read -p "Enter your full name for Git: " git_name
read -p "Enter your email for Git: " git_email

# Basic identity setup
print_status "Setting up Git identity..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"

# Default branch name
print_status "Setting default branch name to main..."
git config --global init.defaultBranch main

# Core configurations
print_status "Configuring Git defaults..."
# Use macOS keychain for credential storage
git config --global credential.helper osxkeychain
# Enable parallel index preload for operations like git diff
git config --global core.preloadindex true
# Use UTF-8 for commit messages and files
git config --global core.quotepath false
# Cache Git credentials for 1 hour
git config --global credential.helper 'cache --timeout=3600'

# Pull behavior
print_status "Setting up pull behavior..."
# Default pull strategy to rebase
git config --global pull.rebase true

# Push behavior
print_status "Setting up push behavior..."
# Push only the current branch by default
git config --global push.default current

# Helpful aliases
print_status "Setting up Git aliases..."
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.visual "!gitk"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Color configuration
print_status "Enabling color support..."
git config --global color.ui true
git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.status auto

print_status "Git configuration complete! Current settings:"
git config --list

print_status "✅ Git setup complete!"
print_warning "Next steps:"
print_warning "1. If you haven't already, set up SSH keys for GitHub:"
print_warning "   https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
print_warning "2. Configure GitHub CLI (gh) if installed:"
print_warning "   Run: gh auth login" 
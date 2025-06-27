#!/bin/bash

# Mac Setup - Installation Verification Script
# This script checks the status of all installations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_section() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

# Check Homebrew installation
print_section "Homebrew Installation"
if command -v brew &> /dev/null; then
    print_success "Homebrew installed ($(brew --version | head -1))"
    
    # Check PATH
    if echo $PATH | grep -q "/opt/homebrew/bin"; then
        print_success "Homebrew in PATH"
    else
        print_error "Homebrew not in PATH"
        print_warning "Add to ~/.zprofile: eval \"\$(/opt/homebrew/bin/brew shellenv)\""
    fi
else
    print_error "Homebrew not installed"
    exit 1
fi

# Check Brewfile packages
print_section "Brewfile Package Status"

# Read Brewfile and check each package
BREWFILE="${BREWFILE:-scripts/Brewfile}"
if [[ -f "$BREWFILE" ]]; then
    # Check formulae
    while IFS= read -r line; do
        if [[ "$line" =~ ^brew[[:space:]]+\"([^\"]+)\" ]]; then
            package="${BASH_REMATCH[1]}"
            if brew list --formula "$package" &> /dev/null; then
                print_success "Formula: $package"
            else
                print_error "Formula: $package (not installed)"
            fi
        fi
    done < "$BREWFILE"
    
    # Check casks
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$line" ]] && continue
        
        if [[ "$line" =~ ^cask[[:space:]]+\"([^\"]+)\" ]]; then
            package="${BASH_REMATCH[1]}"
            if brew list --cask "$package" &> /dev/null; then
                print_success "Cask: $package"
            else
                print_error "Cask: $package (not installed)"
            fi
        fi
    done < "$BREWFILE"
else
    print_error "Brewfile not found at $BREWFILE"
fi

# Check shell configuration
print_section "Shell Configuration"

# Check shell
echo "Current shell: $SHELL"

# Check asdf
if command -v asdf &> /dev/null; then
    print_success "asdf available"
else
    print_error "asdf not in PATH"
    print_warning "Add to ~/.zshrc: . \$(brew --prefix asdf)/libexec/asdf.sh"
fi

# Check direnv
if command -v direnv &> /dev/null; then
    print_success "direnv available"
else
    print_error "direnv not in PATH"
    print_warning "Add to ~/.zshrc: eval \"\$(direnv hook zsh)\""
fi

# Check for configuration file
if [[ -f ~/Dev/mac-setup/configs/shell/zshrc ]]; then
    if grep -q "Dev/mac-setup/configs/shell/zshrc" ~/.zshrc 2>/dev/null; then
        print_success "Shell configuration sourced in ~/.zshrc"
    else
        print_warning "Shell configuration exists but not sourced"
        print_warning "Add to ~/.zshrc: source ~/Dev/mac-setup/configs/shell/zshrc"
    fi
else
    print_warning "Shell configuration file not found"
fi

# Check special cases
print_section "Known Issues"

# Docker
if brew list --cask docker &> /dev/null; then
    print_success "Docker installed via Homebrew"
elif [[ -d "/Applications/Docker.app" ]]; then
    print_warning "Docker installed outside Homebrew"
else
    print_error "Docker not installed"
fi

# Amphetamine
if [[ -d "/Applications/Amphetamine.app" ]]; then
    print_success "Amphetamine installed (from Mac App Store)"
else
    print_warning "Amphetamine not installed (install from Mac App Store)"
fi

# Summary
print_section "Summary"
echo "Run 'brew bundle check --file=$BREWFILE' for detailed status"
echo "Run 'brew doctor' to check for Homebrew issues"
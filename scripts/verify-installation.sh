#!/bin/bash

# Mac Setup - Installation Verification Script
# This script checks the status of all installations

# Mac Setup - Installation Verification Script
# Note: We don't use 'set -e' here to continue checking even if commands fail

# Capture output for summary
exec > >(tee /tmp/verify_output)
exec 2>&1

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
if [[ -f ~/.zshrc ]]; then
    # Check if Homebrew is configured
    if grep -q "brew shellenv" ~/.zshrc 2>/dev/null; then
        print_success "Homebrew configured in ~/.zshrc"
    else
        print_warning "Homebrew not configured in ~/.zshrc"
        print_warning "Run: ./scripts/configure-shell.sh"
    fi
    
    # Check if asdf is configured
    if grep -q "asdf.sh" ~/.zshrc 2>/dev/null; then
        print_success "asdf configured in ~/.zshrc"
    else
        print_warning "asdf not configured in ~/.zshrc"
    fi
    
    # Check if direnv is configured  
    if grep -q "direnv hook" ~/.zshrc 2>/dev/null; then
        print_success "direnv configured in ~/.zshrc"
    else
        print_warning "direnv not configured in ~/.zshrc"
    fi
else
    print_error "~/.zshrc not found"
    print_warning "Run: ./scripts/configure-shell.sh"
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

# Count issues
ERRORS=$(grep "✗" /tmp/verify_output 2>/dev/null | wc -l | tr -d ' ')
WARNINGS=$(grep "!" /tmp/verify_output 2>/dev/null | wc -l | tr -d ' ') 

if [[ $ERRORS -gt 0 ]]; then
    echo -e "${RED}Found $ERRORS errors${NC}"
fi
if [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}Found $WARNINGS warnings${NC}"
fi

echo ""
echo "Quick fixes:"
echo "1. Configure shell:     ./scripts/configure-shell.sh"
echo "2. Fix Docker:          ./scripts/fix-docker.sh"
echo "3. Retry installations: brew bundle --file=$BREWFILE"
echo "4. Check Homebrew:      brew doctor"
echo ""
echo "For more help, see: docs/troubleshooting.md"
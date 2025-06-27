#!/bin/bash
# Configure minimal shell environment with essential tools and aliases

set -euo pipefail

echo "🐚 Configuring minimal shell environment..."

SHELL_CONFIG="$HOME/.zshrc"

# Create .zshrc if it doesn't exist
if [ ! -f "$SHELL_CONFIG" ]; then
    echo "📝 Creating $SHELL_CONFIG..."
    touch "$SHELL_CONFIG"
fi

# Backup existing config
if [ -f "$SHELL_CONFIG" ] && [ ! -f "$SHELL_CONFIG.backup" ]; then
    cp "$SHELL_CONFIG" "$SHELL_CONFIG.backup"
    echo "📦 Backed up existing config to $SHELL_CONFIG.backup"
fi

# Function to add configuration if not already present
add_to_shell_config() {
    local config_line="$1"
    local comment="$2"
    
    if ! grep -Fq "$config_line" "$SHELL_CONFIG"; then
        echo "" >> "$SHELL_CONFIG"
        echo "# $comment" >> "$SHELL_CONFIG"
        echo "$config_line" >> "$SHELL_CONFIG"
        echo "✅ Added: $comment"
    else
        echo "✓ Already configured: $comment"
    fi
}

# Configure Homebrew
echo ""
echo "🍺 Configuring Homebrew..."
if [ -f "/opt/homebrew/bin/brew" ]; then
    add_to_shell_config 'eval "$(/opt/homebrew/bin/brew shellenv)"' "Homebrew (Apple Silicon)"
elif [ -f "/usr/local/bin/brew" ]; then
    add_to_shell_config 'eval "$(/usr/local/bin/brew shellenv)"' "Homebrew (Intel)"
else
    echo "⚠️  Homebrew not found"
fi

# Configure asdf
echo ""
echo "📦 Configuring asdf..."
if command -v brew &> /dev/null && brew list asdf &> /dev/null; then
    ASDF_DIR="$(brew --prefix asdf)"
    add_to_shell_config ". $ASDF_DIR/libexec/asdf.sh" "asdf version manager"
else
    echo "⚠️  asdf not installed via Homebrew"
fi

# Configure direnv
echo ""
echo "📁 Configuring direnv..."
if command -v direnv &> /dev/null; then
    add_to_shell_config 'eval "$(direnv hook zsh)"' "direnv"
else
    echo "⚠️  direnv not found in PATH"
fi

# Add basic configuration
echo ""
echo "⚙️  Adding basic shell configuration..."

# Check if basic config section exists
if ! grep -q "# Basic shell configuration" "$SHELL_CONFIG"; then
    cat >> "$SHELL_CONFIG" << 'EOF'

# Basic shell configuration
export EDITOR="code"
export VISUAL="$EDITOR"

# Better history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Essential aliases
alias ll='ls -la'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# Development shortcuts
alias dev='cd ~/Dev'
alias py='python3'
alias pip='pip3'

# Docker shortcuts (if installed)
if command -v docker &> /dev/null; then
    alias d='docker'
    alias dc='docker-compose'
fi

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Python virtual environment helpers
mkvenv() {
    python3 -m venv "${1:-venv}" && source "${1:-venv}/bin/activate"
}

activate() {
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    elif [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
    else
        echo "No virtual environment found in current directory"
    fi
}
EOF
    echo "✅ Added basic configuration and aliases"
else
    echo "✓ Basic configuration already present"
fi

# Source the updated configuration
echo ""
echo "🔄 Testing configuration..."
zsh -c "source $SHELL_CONFIG" 2>/dev/null || {
    echo "⚠️  Warning: Configuration test failed. Please check ~/.zshrc for errors."
}

echo ""
echo "✅ Shell configuration complete!"
echo ""
echo "📝 To activate:"
echo "   source ~/.zshrc"
echo ""
echo "🎯 What's configured:"
echo "   - Homebrew PATH"
echo "   - asdf version manager"
echo "   - direnv environment loader"
echo "   - Essential aliases (ll, g, py, etc.)"
echo "   - Python virtual environment helpers"
echo "   - Better command history"
echo ""
echo "💡 For a more feature-rich setup, run:"
echo "   ./scripts/setup-shell-enhanced.sh"
#!/bin/bash
# Enhanced shell setup with Oh My Zsh and additional features
# WARNING: This adds significant complexity to your shell environment

set -e

echo "🚀 Enhanced Shell Setup"
echo "⚠️  WARNING: This will install Oh My Zsh and multiple plugins."
echo "⚠️  This adds complexity and may slow down shell startup."
echo ""
read -p "Continue with enhanced setup? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled. Run ./scripts/configure-shell.sh for minimal setup."
    exit 0
fi

# Ensure basic setup is done first
if ! grep -q "Homebrew" ~/.zshrc 2>/dev/null; then
    echo "📝 Running basic configuration first..."
    ./scripts/configure-shell.sh
fi

echo ""
echo "🐚 Installing Oh My Zsh..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Restore our configuration that Oh My Zsh overwrote
    if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
        cat "$HOME/.zshrc.pre-oh-my-zsh" >> "$HOME/.zshrc"
    fi
else
    echo "✓ Oh My Zsh already installed"
fi

# Create enhanced configuration
echo ""
echo "📝 Creating enhanced configuration..."

# Backup current .zshrc
cp ~/.zshrc ~/.zshrc.enhanced-backup

# Create new .zshrc with Oh My Zsh
cat > ~/.zshrc << 'EOF'
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme - use simple robbyrussell for speed
ZSH_THEME="robbyrussell"

# Minimal plugin set for performance
plugins=(
    git
    docker
    python
    pip
)

# Oh My Zsh settings for better performance
DISABLE_AUTO_UPDATE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

source $ZSH/oh-my-zsh.sh

# User configuration
EOF

# Append existing configuration
if [ -f ~/.zshrc.enhanced-backup ]; then
    echo "" >> ~/.zshrc
    echo "# Existing configuration" >> ~/.zshrc
    grep -v "^export ZSH=" ~/.zshrc.enhanced-backup | grep -v "^source \$ZSH/oh-my-zsh.sh" >> ~/.zshrc
fi

# Install useful but lightweight plugins
echo ""
echo "📦 Installing lightweight plugins..."

# zsh-autosuggestions (very useful, minimal overhead)
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    
    # Add to plugins
    sed -i '' 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc
    echo "✅ Installed zsh-autosuggestions"
else
    echo "✓ zsh-autosuggestions already installed"
fi

# Add enhanced aliases
if ! grep -q "# Enhanced aliases" ~/.zshrc; then
    cat >> ~/.zshrc << 'EOF'

# Enhanced aliases
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"
alias reload="source ~/.zshrc"

# Advanced git aliases
alias gaa='git add --all'
alias gcam='git commit -am'
alias gf='git fetch'
alias gfo='git fetch origin'
alias glg='git log --stat'
alias glog='git log --oneline --decorate --graph'
alias gr='git remote'
alias grv='git remote -v'
alias gst='git status'
alias gup='git pull --rebase'

# Docker compose v2
alias dco='docker compose'
alias dcup='docker compose up'
alias dcdown='docker compose down'
alias dclogs='docker compose logs -f'

# Python development
alias pf='pip freeze'
alias pfr='pip freeze > requirements.txt'
alias pir='pip install -r requirements.txt'
alias pytest='python -m pytest'

# System monitoring
alias cpu='top -o cpu'
alias mem='top -o mem'
alias disk='df -h'
alias usage='du -sh *'

# Quick edits
alias hosts='sudo $EDITOR /etc/hosts'
alias sshconfig='$EDITOR ~/.ssh/config'
EOF
    echo "✅ Added enhanced aliases"
fi

echo ""
echo "✅ Enhanced shell setup complete!"
echo ""
echo "📝 What's added:"
echo "   - Oh My Zsh framework"
echo "   - Git plugin with advanced aliases"
echo "   - Docker & Python plugins"
echo "   - Zsh autosuggestions"
echo "   - Enhanced aliases and shortcuts"
echo ""
echo "⚡ To activate:"
echo "   source ~/.zshrc"
echo ""
echo "💡 Tips:"
echo "   - View all aliases: alias"
echo "   - Edit config: zshconfig"
echo "   - Reload shell: reload"
echo ""
echo "⚠️  If shell feels slow, run ./scripts/configure-shell.sh to revert to minimal setup"
#!/bin/bash
# Configure shell environment for Homebrew, asdf, and direnv

set -euo pipefail

echo "🐚 Configuring shell environment..."

SHELL_CONFIG="$HOME/.zshrc"

# Create .zshrc if it doesn't exist
if [ ! -f "$SHELL_CONFIG" ]; then
    echo "📝 Creating $SHELL_CONFIG..."
    touch "$SHELL_CONFIG"
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
    add_to_shell_config 'eval "$(/opt/homebrew/bin/brew shellenv)"' "Homebrew"
else
    echo "⚠️  Homebrew not found at /opt/homebrew/bin/brew"
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

# Source the updated configuration
echo ""
echo "🔄 Loading new configuration..."
source "$SHELL_CONFIG" 2>/dev/null || true

echo ""
echo "✅ Shell configuration complete!"
echo ""
echo "📝 Next steps:"
echo "1. Open a new terminal window or tab"
echo "2. Or run: source ~/.zshrc"
echo ""
echo "To verify:"
echo "- Homebrew: brew --version"
echo "- asdf: asdf --version"
echo "- direnv: direnv --version"
#!/bin/bash
# Fix Docker installation issues

set -euo pipefail

echo "🐳 Fixing Docker installation..."

# Check if Docker.app exists
if [ -d "/Applications/Docker.app" ]; then
    echo "⚠️  Found existing Docker.app installation"
    
    # Check if Docker is running
    if pgrep -f "Docker Desktop" > /dev/null; then
        echo "❌ Docker Desktop is currently running. Please quit Docker Desktop and try again."
        exit 1
    fi
    
    echo "🗑️  Removing existing Docker.app to allow clean installation..."
    sudo rm -rf "/Applications/Docker.app" || {
        echo "❌ Failed to remove Docker.app. You may need to manually move it to Trash."
        echo "   Try: sudo rm -rf /Applications/Docker.app"
        exit 1
    }
fi

# Try to install Docker via Homebrew
echo "📦 Installing Docker Desktop via Homebrew..."
brew install --cask docker || {
    echo "❌ Docker installation failed"
    echo ""
    echo "Alternative installation methods:"
    echo "1. Download Docker Desktop directly from: https://www.docker.com/products/docker-desktop/"
    echo "2. If you have an existing Docker installation, fully uninstall it first:"
    echo "   - Quit Docker Desktop"
    echo "   - Move Docker.app to Trash"
    echo "   - Remove Docker settings: rm -rf ~/Library/Group\ Containers/group.com.docker"
    echo "   - Remove Docker data: rm -rf ~/Library/Containers/com.docker.docker"
    echo "   - Then run: brew install --cask docker"
    exit 1
}

echo "✅ Docker Desktop installed successfully!"
echo ""
echo "📝 Next steps:"
echo "1. Open Docker Desktop from Applications"
echo "2. Complete the Docker Desktop setup wizard"
echo "3. Verify installation with: docker --version"
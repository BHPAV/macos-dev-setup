#!/bin/bash
# Deep clean Docker installation for fresh install

echo "🧹 Deep cleaning Docker installation..."
echo "This will remove all Docker-related files and require sudo access."
echo ""

# Check if Docker is running
if pgrep -f "Docker Desktop" > /dev/null; then
    echo "❌ Docker Desktop is currently running. Please quit Docker Desktop first."
    exit 1
fi

echo "⚠️  This script will remove:"
echo "- Docker.app (if exists)"
echo "- Docker CLI symlinks in /usr/local/bin"
echo "- Docker bash completions"
echo "- Docker data and settings (optional)"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Remove Docker.app
if [ -d "/Applications/Docker.app" ]; then
    echo "🗑️  Removing Docker.app..."
    sudo rm -rf "/Applications/Docker.app" 2>/dev/null || echo "Failed to remove Docker.app"
fi

# Remove symlinks
echo "🔗 Removing Docker symlinks..."
DOCKER_BINS=(
    "compose-bridge"
    "docker"
    "docker-compose"
    "docker-credential-desktop"
    "docker-credential-osxkeychain"
    "hub-tool"
    "kubectl"
    "kubectl.docker"
)

for bin in "${DOCKER_BINS[@]}"; do
    if [ -L "/usr/local/bin/$bin" ]; then
        echo "  Removing /usr/local/bin/$bin"
        sudo rm -f "/usr/local/bin/$bin" 2>/dev/null
    fi
done

# Remove bash completions
echo "📝 Removing bash completions..."
sudo rm -f /opt/homebrew/etc/bash_completion.d/docker* 2>/dev/null
sudo rm -f /usr/local/etc/bash_completion.d/docker* 2>/dev/null

# Ask about data removal
echo ""
read -p "Remove Docker data and settings? This will delete all containers/images! (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "💾 Removing Docker data..."
    rm -rf ~/Library/Group\ Containers/group.com.docker 2>/dev/null
    rm -rf ~/Library/Containers/com.docker.docker 2>/dev/null
    rm -rf ~/.docker 2>/dev/null
fi

echo ""
echo "✅ Docker deep clean complete!"
echo ""
echo "📝 Next steps:"
echo "1. Install Docker: brew install --cask docker"
echo "2. Or download from: https://www.docker.com/products/docker-desktop/"
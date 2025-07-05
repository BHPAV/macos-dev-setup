#!/bin/bash

# Mac Setup - Optimized Development Environment Setup Script
# This script sets up development tools with parallel processing and resource optimization

set -e

echo "🚀 Setting up optimized development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$HOME/.cache/mac-setup"
LOG_DIR="$HOME/.cache/mac-setup/logs"
PROGRESS_FILE="$HOME/.cache/mac-setup/progress"
CONFIG_FILE="$HOME/.config/mac-setup/config.json"

# System info
CPU_CORES=$(sysctl -n hw.ncpu)
MEMORY_GB=$(echo "$(sysctl -n hw.memsize) / 1024 / 1024 / 1024" | bc)
DISK_AVAIL_GB=$(df -g / | tail -1 | awk '{print $4}')

# Installation profile
PROFILE="${1:-minimal}"
PARALLEL_JOBS=$((CPU_CORES > 4 ? CPU_CORES - 2 : CPU_CORES))

# Create directories
mkdir -p "$CACHE_DIR" "$LOG_DIR" "$(dirname "$CONFIG_FILE")"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_DIR/setup.log"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_DIR/setup.log"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_DIR/setup.log"
}

print_progress() {
    echo -e "${BLUE}[PROGRESS]${NC} $1"
}

# Progress tracking
init_progress() {
    cat > "$PROGRESS_FILE" << EOF
{
    "started": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "profile": "$PROFILE",
    "steps": {},
    "system": {
        "cpu_cores": $CPU_CORES,
        "memory_gb": $MEMORY_GB,
        "disk_avail_gb": $DISK_AVAIL_GB
    }
}
EOF
}

mark_step_complete() {
    local step=$1
    local start_time=$2
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Update progress file (simplified JSON update)
    echo "Step '$step' completed in ${duration}s" >> "$LOG_DIR/progress.log"
}

# Resource monitoring
check_resources() {
    print_status "Checking system resources..."
    
    if [[ $MEMORY_GB -lt 4 ]]; then
        print_warning "Low memory detected (${MEMORY_GB}GB). Consider closing other applications."
    fi
    
    if [[ $DISK_AVAIL_GB -lt 10 ]]; then
        print_error "Insufficient disk space (${DISK_AVAIL_GB}GB available). Need at least 10GB."
        exit 1
    fi
    
    print_status "System resources OK: ${CPU_CORES} cores, ${MEMORY_GB}GB RAM, ${DISK_AVAIL_GB}GB free"
}

# Enhanced prerequisite checking
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_deps=()
    
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    if ! command -v brew &> /dev/null; then
        missing_deps+=("homebrew")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_error "Please install them first."
        exit 1
    fi
    
    print_status "Prerequisites check passed."
}

# Optimized asdf installation with caching
install_asdf_optimized() {
    local start_time=$(date +%s)
    print_status "Installing asdf version manager..."
    
    if [ -d "$HOME/.asdf" ]; then
        print_status "asdf already installed. Updating..."
        cd ~/.asdf && git pull origin master --quiet
    else
        print_status "Cloning asdf repository..."
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1 --quiet
        
        # Configure shell integration
        if ! grep -q "asdf.sh" ~/.zshrc 2>/dev/null; then
            echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
            echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
        fi
    fi
    
    # Source asdf for current session
    source ~/.asdf/asdf.sh
    
    mark_step_complete "asdf_install" $start_time
}

# Parallel language installation
install_languages_parallel() {
    local start_time=$(date +%s)
    print_status "Installing programming languages in parallel..."
    
    # Create installation functions for parallel execution
    install_python_async() {
        print_status "Installing Python..."
        asdf plugin add python 2>/dev/null || true
        asdf install python 3.12.1 2>/dev/null || true
        asdf global python 3.12.1
        echo "Python installation complete" >> "$LOG_DIR/python.log"
    }
    
    install_nodejs_async() {
        print_status "Installing Node.js..."
        asdf plugin add nodejs 2>/dev/null || true
        asdf install nodejs 20.10.0 2>/dev/null || true
        asdf global nodejs 20.10.0
        echo "Node.js installation complete" >> "$LOG_DIR/nodejs.log"
    }
    
    install_ruby_async() {
        print_status "Installing Ruby..."
        asdf plugin add ruby 2>/dev/null || true
        asdf install ruby 3.2.2 2>/dev/null || true
        asdf global ruby 3.2.2
        echo "Ruby installation complete" >> "$LOG_DIR/ruby.log"
    }
    
    install_go_async() {
        print_status "Installing Go..."
        asdf plugin add golang 2>/dev/null || true
        asdf install golang 1.21.5 2>/dev/null || true
        asdf global golang 1.21.5
        echo "Go installation complete" >> "$LOG_DIR/go.log"
    }
    
    # Run installations in parallel based on profile
    local pids=()
    
    case "$PROFILE" in
        minimal)
            install_python_async &
            pids+=($!)
            install_nodejs_async &
            pids+=($!)
            ;;
        python)
            install_python_async &
            pids+=($!)
            ;;
        full)
            install_python_async &
            pids+=($!)
            install_nodejs_async &
            pids+=($!)
            install_ruby_async &
            pids+=($!)
            install_go_async &
            pids+=($!)
            ;;
        *)
            print_error "Unknown profile: $PROFILE"
            exit 1
            ;;
    esac
    
    # Wait for all language installations to complete
    print_progress "Waiting for language installations to complete..."
    for pid in "${pids[@]}"; do
        wait "$pid" || print_warning "One language installation may have failed"
    done
    
    mark_step_complete "languages_parallel" $start_time
}

# Optimized package installation with minimal sets
install_python_packages_minimal() {
    local start_time=$(date +%s)
    print_status "Installing essential Python packages..."
    
    # Core development tools only
    pip install --upgrade pip --quiet
    pip install --quiet \
        black \
        flake8 \
        pytest \
        ipython \
        requests \
        flask
    
    # Only install ML packages if explicitly requested
    if [[ "$PROFILE" == "full" ]]; then
        pip install --quiet \
            pandas \
            numpy \
            matplotlib \
            scikit-learn
    fi
    
    mark_step_complete "python_packages" $start_time
}

# Optimized Node.js packages
install_node_packages_minimal() {
    local start_time=$(date +%s)
    print_status "Installing essential Node.js packages..."
    
    # Essential packages only
    npm install -g --silent \
        typescript \
        nodemon \
        eslint \
        prettier
    
    # Framework CLI tools only if full profile
    if [[ "$PROFILE" == "full" ]]; then
        npm install -g --silent \
            create-react-app \
            create-next-app
    fi
    
    mark_step_complete "node_packages" $start_time
}

# Optimized Ruby gems
install_ruby_gems_minimal() {
    local start_time=$(date +%s)
    print_status "Installing essential Ruby gems..."
    
    gem install --silent \
        bundler \
        rails \
        rspec \
        rubocop
    
    mark_step_complete "ruby_gems" $start_time
}

# Optimized Go packages
install_go_packages_minimal() {
    local start_time=$(date +%s)
    print_status "Installing essential Go packages..."
    
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    
    mark_step_complete "go_packages" $start_time
}

# Parallel package installation
install_packages_parallel() {
    local start_time=$(date +%s)
    print_status "Installing packages in parallel..."
    
    local pids=()
    
    # Install packages in parallel based on installed languages
    if command -v python &> /dev/null; then
        install_python_packages_minimal &
        pids+=($!)
    fi
    
    if command -v node &> /dev/null; then
        install_node_packages_minimal &
        pids+=($!)
    fi
    
    if command -v ruby &> /dev/null; then
        install_ruby_gems_minimal &
        pids+=($!)
    fi
    
    if command -v go &> /dev/null; then
        install_go_packages_minimal &
        pids+=($!)
    fi
    
    # Wait for all package installations
    for pid in "${pids[@]}"; do
        wait "$pid" || print_warning "One package installation may have failed"
    done
    
    mark_step_complete "packages_parallel" $start_time
}

# Optimized VS Code extensions
install_vscode_extensions_minimal() {
    local start_time=$(date +%s)
    print_status "Installing essential VS Code extensions..."
    
    if ! command -v code &> /dev/null; then
        print_warning "VS Code not found. Skipping extensions."
        return
    fi
    
    # Essential extensions only
    local extensions=(
        "ms-python.python"
        "ms-vscode.vscode-typescript-next"
        "ms-python.black-formatter"
        "ms-vscode.vscode-json"
        "ms-vscode.vscode-git"
    )
    
    for ext in "${extensions[@]}"; do
        code --install-extension "$ext" --force &
    done
    
    wait
    
    mark_step_complete "vscode_extensions" $start_time
}

# Optimized Git configuration
setup_git_optimized() {
    local start_time=$(date +%s)
    print_status "Setting up optimized Git configuration..."
    
    # Only create gitignore if it doesn't exist
    if [[ ! -f ~/.gitignore_global ]]; then
        curl -sL https://raw.githubusercontent.com/github/gitignore/main/Global/macOS.gitignore > ~/.gitignore_global
        curl -sL https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore >> ~/.gitignore_global
        curl -sL https://raw.githubusercontent.com/github/gitignore/main/Node.gitignore >> ~/.gitignore_global
        
        git config --global core.excludesfile ~/.gitignore_global
    fi
    
    # Configure essential git settings
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global push.default simple
    git config --global core.autocrlf input
    git config --global rerere.enabled true
    
    mark_step_complete "git_config" $start_time
}

# Cleanup and optimization
cleanup_optimized() {
    local start_time=$(date +%s)
    print_status "Cleaning up and optimizing..."
    
    # Clean package manager caches
    if command -v brew &> /dev/null; then
        brew cleanup --prune=7 &
    fi
    
    if command -v pip &> /dev/null; then
        pip cache purge &
    fi
    
    if command -v npm &> /dev/null; then
        npm cache clean --force &
    fi
    
    wait
    
    # Clean up temporary files
    rm -rf "$HOME/.cache/mac-setup/tmp" 2>/dev/null || true
    
    mark_step_complete "cleanup" $start_time
}

# Enhanced verification
verify_installations_optimized() {
    local start_time=$(date +%s)
    print_status "Verifying installations..."
    
    local success=0
    local total=0
    
    # Check languages
    local languages=("python" "node" "git")
    
    if [[ "$PROFILE" == "full" ]]; then
        languages+=("ruby" "go")
    fi
    
    for lang in "${languages[@]}"; do
        total=$((total + 1))
        if command -v "$lang" &> /dev/null; then
            version=$($lang --version 2>/dev/null | head -n1 | cut -d' ' -f2)
            print_status "✅ $lang installed: $version"
            success=$((success + 1))
        else
            print_warning "❌ $lang not found"
        fi
    done
    
    # Calculate success rate
    local success_rate=$((success * 100 / total))
    print_status "Installation success rate: ${success_rate}%"
    
    if [[ $success_rate -lt 80 ]]; then
        print_warning "Some installations failed. Check logs in $LOG_DIR"
    fi
    
    mark_step_complete "verification" $start_time
}

# Performance monitoring
monitor_performance() {
    local start_time=$1
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    print_status "📊 Performance Summary:"
    print_status "Total installation time: ${duration}s ($(date -u -d @$duration +%H:%M:%S))"
    print_status "Profile: $PROFILE"
    print_status "Parallel jobs: $PARALLEL_JOBS"
    print_status "System: ${CPU_CORES} cores, ${MEMORY_GB}GB RAM"
    print_status "Logs available in: $LOG_DIR"
}

# Main execution with profile support
main() {
    local overall_start_time=$(date +%s)
    
    # Initialize
    init_progress
    
    print_status "🚀 Starting optimized setup with profile: $PROFILE"
    print_status "Using $PARALLEL_JOBS parallel jobs on $CPU_CORES cores"
    
    # Core setup
    check_resources
    check_prerequisites
    install_asdf_optimized
    
    # Language and package installation
    install_languages_parallel
    install_packages_parallel
    
    # Tool configuration
    install_vscode_extensions_minimal
    setup_git_optimized
    
    # Cleanup and verification
    cleanup_optimized
    verify_installations_optimized
    
    # Performance monitoring
    monitor_performance $overall_start_time
    
    print_status "✅ Optimized development environment setup complete!"
    print_status "💡 Next steps:"
    print_status "   1. Restart your terminal or run: source ~/.zshrc"
    print_status "   2. Configure Git user: git config --global user.name 'Your Name'"
    print_status "   3. Configure Git email: git config --global user.email 'your@email.com'"
    print_status "   4. Check installation: ./scripts/verify-installation.sh"
    
    # Show profile-specific tips
    case "$PROFILE" in
        minimal)
            print_status "💡 Minimal profile completed. Run with --profile=full for complete setup."
            ;;
        python)
            print_status "💡 Python profile completed. Ready for Python development!"
            ;;
        full)
            print_status "💡 Full profile completed. All development tools installed!"
            ;;
    esac
}

# Show usage information
show_usage() {
    echo "Usage: $0 [PROFILE]"
    echo ""
    echo "Available profiles:"
    echo "  minimal  - Essential tools only (Python, Node.js, Git) - ~15 min"
    echo "  python   - Python development focus - ~30 min"
    echo "  full     - Complete development stack - ~60 min"
    echo ""
    echo "Examples:"
    echo "  $0 minimal"
    echo "  $0 python"
    echo "  $0 full"
}

# Handle command line arguments
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

# Run main function
main "$@"
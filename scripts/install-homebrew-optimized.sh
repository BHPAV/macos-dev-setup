#!/bin/bash

# Mac Setup - Optimized Homebrew Installation Script
# This script installs Homebrew with performance optimizations and tiered installation

set -e

echo "🚀 Installing Homebrew with optimizations..."

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
PROFILE="${1:-minimal}"
BREWFILE="${2:-$SCRIPT_DIR/Brewfile.optimized}"

# System info
CPU_CORES=$(sysctl -n hw.ncpu)
MEMORY_GB=$(echo "$(sysctl -n hw.memsize) / 1024 / 1024 / 1024" | bc)
DISK_AVAIL_GB=$(df -g / | tail -1 | awk '{print $4}')
PARALLEL_JOBS=$((CPU_CORES > 4 ? CPU_CORES - 2 : CPU_CORES))

# Create directories
mkdir -p "$CACHE_DIR" "$LOG_DIR"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_DIR/homebrew-install.log"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_DIR/homebrew-install.log"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_DIR/homebrew-install.log"
}

print_progress() {
    echo -e "${BLUE}[PROGRESS]${NC} $1"
}

# Resource check
check_system_resources() {
    print_status "Checking system resources..."
    
    print_status "System: ${CPU_CORES} cores, ${MEMORY_GB}GB RAM, ${DISK_AVAIL_GB}GB free"
    
    if [[ $MEMORY_GB -lt 4 ]]; then
        print_warning "Low memory detected (${MEMORY_GB}GB). Installation may be slow."
    fi
    
    if [[ $DISK_AVAIL_GB -lt 5 ]]; then
        print_error "Insufficient disk space (${DISK_AVAIL_GB}GB available). Need at least 5GB."
        exit 1
    fi
    
    print_status "System resources check passed."
}

# Optimized Homebrew installation
install_homebrew_optimized() {
    local start_time=$(date +%s)
    
    if command -v brew &> /dev/null; then
        print_status "Homebrew already installed. Optimizing..."
        
        # Update Homebrew
        print_progress "Updating Homebrew..."
        brew update --quiet
        
        # Optimize Homebrew settings
        export HOMEBREW_NO_ANALYTICS=1
        export HOMEBREW_NO_INSECURE_REDIRECT=1
        export HOMEBREW_CASK_OPTS="--require-sha"
        export HOMEBREW_MAKE_JOBS=$PARALLEL_JOBS
        
        # Cache optimization
        print_progress "Optimizing cache..."
        brew cleanup --prune=7 &
        
    else
        print_status "Installing Homebrew..."
        
        # Set environment variables for faster installation
        export HOMEBREW_NO_ANALYTICS=1
        export HOMEBREW_NO_INSECURE_REDIRECT=1
        export HOMEBREW_MAKE_JOBS=$PARALLEL_JOBS
        
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            print_status "Configuring PATH for Apple Silicon..."
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        # Configure Homebrew optimizations
        print_status "Configuring Homebrew optimizations..."
        brew analytics off
        brew cleanup --prune=7 &
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    print_status "Homebrew setup completed in ${duration}s"
}

# Create optimized Brewfile based on profile
create_profile_brewfile() {
    local profile_brewfile="$CACHE_DIR/Brewfile.${PROFILE}"
    
    print_status "Creating Brewfile for profile: $PROFILE"
    
    # Base tools (always included)
    cat > "$profile_brewfile" << 'EOF'
# Essential tools for all profiles
brew "git"
brew "gh"
brew "asdf"
brew "direnv"

# Essential GUI apps
cask "visual-studio-code"
cask "iterm2"
cask "rectangle"
EOF
    
    # Add profile-specific tools
    case "$PROFILE" in
        minimal)
            # Already have base tools
            ;;
        python)
            cat >> "$profile_brewfile" << 'EOF'

# Python development tools
brew "make"
brew "jq"
cask "tableplus"
EOF
            ;;
        full)
            cat >> "$profile_brewfile" << 'EOF'

# Full development stack
brew "make"
brew "jq"
brew "curl"
brew "wget"

# Development apps
cask "docker"
cask "tableplus"
cask "insomnia"

# Communication
cask "slack"
cask "zoom"

# Productivity
cask "1password"
cask "onedrive"
cask "alfred"
cask "cleanshot"
cask "vlc"
EOF
            ;;
        *)
            print_error "Unknown profile: $PROFILE"
            exit 1
            ;;
    esac
    
    echo "$profile_brewfile"
}

# Parallel installation with batching
install_packages_parallel() {
    local brewfile=$1
    local start_time=$(date +%s)
    
    print_status "Installing packages in parallel from: $brewfile"
    
    # Extract formulae and casks
    local formulae=$(grep '^brew ' "$brewfile" | cut -d'"' -f2 | tr '\n' ' ')
    local casks=$(grep '^cask ' "$brewfile" | cut -d'"' -f2 | tr '\n' ' ')
    
    local pids=()
    
    # Install formulae in parallel (in batches)
    if [[ -n "$formulae" ]]; then
        print_progress "Installing formulae: $formulae"
        
        # Split formulae into batches
        local formula_array=($formulae)
        local batch_size=3
        
        for ((i=0; i<${#formula_array[@]}; i+=batch_size)); do
            local batch=("${formula_array[@]:i:batch_size}")
            
            # Install batch in background
            (
                for formula in "${batch[@]}"; do
                    print_progress "Installing formula: $formula"
                    brew install "$formula" 2>&1 | tee -a "$LOG_DIR/formula-${formula}.log"
                done
            ) &
            
            pids+=($!)
            
            # Limit concurrent jobs
            if [[ ${#pids[@]} -ge $PARALLEL_JOBS ]]; then
                wait "${pids[0]}"
                pids=("${pids[@]:1}")
            fi
        done
    fi
    
    # Install casks in parallel (in batches)
    if [[ -n "$casks" ]]; then
        print_progress "Installing casks: $casks"
        
        # Split casks into batches
        local cask_array=($casks)
        local batch_size=2  # Smaller batch size for casks (larger downloads)
        
        for ((i=0; i<${#cask_array[@]}; i+=batch_size)); do
            local batch=("${cask_array[@]:i:batch_size}")
            
            # Install batch in background
            (
                for cask in "${batch[@]}"; do
                    print_progress "Installing cask: $cask"
                    
                    # Special handling for Docker (common conflict)
                    if [[ "$cask" == "docker" ]] && [[ -d "/Applications/Docker.app" ]]; then
                        print_warning "Docker already exists, skipping..."
                        continue
                    fi
                    
                    brew install --cask "$cask" 2>&1 | tee -a "$LOG_DIR/cask-${cask}.log"
                done
            ) &
            
            pids+=($!)
            
            # Limit concurrent jobs
            if [[ ${#pids[@]} -ge $PARALLEL_JOBS ]]; then
                wait "${pids[0]}"
                pids=("${pids[@]:1}")
            fi
        done
    fi
    
    # Wait for all installations to complete
    print_progress "Waiting for all installations to complete..."
    for pid in "${pids[@]}"; do
        wait "$pid" || print_warning "One package installation may have failed"
    done
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    print_status "Package installation completed in ${duration}s"
}

# Optimized cleanup
cleanup_optimized() {
    local start_time=$(date +%s)
    
    print_status "Running optimized cleanup..."
    
    # Parallel cleanup operations
    local pids=()
    
    # Cleanup Homebrew
    print_progress "Cleaning Homebrew cache..."
    brew cleanup --prune=7 &
    pids+=($!)
    
    # Cleanup downloads
    print_progress "Cleaning download cache..."
    rm -rf "$HOME/Library/Caches/Homebrew/downloads" &
    pids+=($!)
    
    # Wait for cleanup to complete
    for pid in "${pids[@]}"; do
        wait "$pid" 2>/dev/null || true
    done
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    print_status "Cleanup completed in ${duration}s"
}

# Verification with performance monitoring
verify_installation() {
    local start_time=$(date +%s)
    
    print_status "Verifying installation..."
    
    # Check Homebrew
    if command -v brew &> /dev/null; then
        print_status "✅ Homebrew installed: $(brew --version | head -1)"
    else
        print_error "❌ Homebrew not found"
        return 1
    fi
    
    # Check Homebrew doctor
    print_progress "Running Homebrew doctor..."
    if brew doctor &> /dev/null; then
        print_status "✅ Homebrew doctor: OK"
    else
        print_warning "⚠️ Homebrew doctor found issues"
    fi
    
    # Quick package verification
    local essential_tools=("git" "gh" "asdf" "direnv")
    local missing=()
    
    for tool in "${essential_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            print_status "✅ $tool installed"
        else
            missing+=("$tool")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_warning "Missing tools: ${missing[*]}"
        print_warning "Run: brew install ${missing[*]}"
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    print_status "Verification completed in ${duration}s"
}

# Performance summary
show_performance_summary() {
    local total_time=$1
    
    print_status "📊 Performance Summary:"
    print_status "Profile: $PROFILE"
    print_status "Total time: ${total_time}s"
    print_status "Parallel jobs: $PARALLEL_JOBS"
    print_status "System: ${CPU_CORES} cores, ${MEMORY_GB}GB RAM"
    print_status "Disk space used: ~$(brew --cache | xargs du -sh 2>/dev/null | cut -f1)B"
    print_status "Logs available in: $LOG_DIR"
}

# Main execution
main() {
    local overall_start_time=$(date +%s)
    
    print_status "🚀 Starting optimized Homebrew installation"
    print_status "Profile: $PROFILE"
    print_status "Using $PARALLEL_JOBS parallel jobs"
    
    # System check
    check_system_resources
    
    # Install Homebrew
    install_homebrew_optimized
    
    # Create profile-specific Brewfile
    local profile_brewfile
    profile_brewfile=$(create_profile_brewfile)
    
    # Install packages
    install_packages_parallel "$profile_brewfile"
    
    # Cleanup
    cleanup_optimized
    
    # Verify installation
    verify_installation
    
    # Performance summary
    local overall_end_time=$(date +%s)
    local overall_duration=$((overall_end_time - overall_start_time))
    show_performance_summary $overall_duration
    
    print_status "✅ Optimized Homebrew installation complete!"
    print_status "💡 Next steps:"
    print_status "   1. Run development environment setup: ./scripts/setup-dev-optimized.sh $PROFILE"
    print_status "   2. Verify installation: ./scripts/verify-installation-optimized.sh $PROFILE"
    print_status "   3. Configure shell: source ~/.zprofile"
    
    # Profile-specific recommendations
    case "$PROFILE" in
        minimal)
            print_status "💡 Minimal profile installed. Consider 'full' profile for complete setup."
            ;;
        python)
            print_status "💡 Python profile installed. Ready for Python development!"
            ;;
        full)
            print_status "💡 Full profile installed. Complete development environment ready!"
            ;;
    esac
}

# Show usage
show_usage() {
    echo "Usage: $0 [PROFILE] [BREWFILE]"
    echo ""
    echo "Available profiles:"
    echo "  minimal  - Essential tools only (~200MB, ~5min)"
    echo "  python   - Python development focus (~400MB, ~8min)"
    echo "  full     - Complete development stack (~800MB, ~15min)"
    echo ""
    echo "Examples:"
    echo "  $0 minimal"
    echo "  $0 python"
    echo "  $0 full"
    echo "  $0 minimal /path/to/custom/Brewfile"
}

# Handle command line arguments
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

# Validate profile
case "$PROFILE" in
    minimal|python|full)
        ;;
    *)
        print_error "Invalid profile: $PROFILE"
        show_usage
        exit 1
        ;;
esac

# Run main function
main "$@"
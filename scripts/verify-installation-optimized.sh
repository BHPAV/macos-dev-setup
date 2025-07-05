#!/bin/bash

# Mac Setup - Optimized Installation Verification Script
# This script checks installations in parallel for faster verification

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CACHE_DIR="$HOME/.cache/mac-setup"
LOG_DIR="$HOME/.cache/mac-setup/logs"
RESULTS_FILE="$CACHE_DIR/verification_results.json"
PROFILE="${1:-auto}"

# Create directories
mkdir -p "$CACHE_DIR" "$LOG_DIR"

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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_section() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

# Performance monitoring
start_time=$(date +%s)
verification_results=()

# Initialize results tracking
init_results() {
    cat > "$RESULTS_FILE" << EOF
{
    "started": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "profile": "$PROFILE",
    "system": {
        "cpu_cores": $(sysctl -n hw.ncpu),
        "memory_gb": $(echo "$(sysctl -n hw.memsize) / 1024 / 1024 / 1024" | bc)
    },
    "checks": {}
}
EOF
}

# Parallel verification functions
verify_homebrew() {
    local result_file="$LOG_DIR/homebrew_check.tmp"
    
    if command -v brew &> /dev/null; then
        local version=$(brew --version | head -1)
        echo "✓ Homebrew: $version" > "$result_file"
        
        # Check PATH
        if echo $PATH | grep -q "/opt/homebrew/bin\|/usr/local/bin"; then
            echo "✓ Homebrew in PATH" >> "$result_file"
        else
            echo "✗ Homebrew not in PATH" >> "$result_file"
        fi
        
        # Check for common issues
        if brew doctor &> /dev/null; then
            echo "✓ Homebrew doctor: OK" >> "$result_file"
        else
            echo "! Homebrew doctor: Issues detected" >> "$result_file"
        fi
    else
        echo "✗ Homebrew not installed" > "$result_file"
    fi
}

verify_languages() {
    local result_file="$LOG_DIR/languages_check.tmp"
    local languages=("python" "node" "ruby" "go" "java" "php" "rustc")
    
    for lang in "${languages[@]}"; do
        if command -v "$lang" &> /dev/null; then
            local version=$($lang --version 2>/dev/null | head -n1)
            echo "✓ $lang: $version" >> "$result_file"
        else
            echo "✗ $lang: not found" >> "$result_file"
        fi
    done
}

verify_development_tools() {
    local result_file="$LOG_DIR/devtools_check.tmp"
    local tools=("git" "gh" "asdf" "direnv" "make" "docker" "code")
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            local version=$($tool --version 2>/dev/null | head -n1)
            echo "✓ $tool: $version" >> "$result_file"
        else
            echo "✗ $tool: not found" >> "$result_file"
        fi
    done
}

verify_applications() {
    local result_file="$LOG_DIR/applications_check.tmp"
    local apps=(
        "Visual Studio Code:/Applications/Visual Studio Code.app"
        "iTerm2:/Applications/iTerm.app"
        "Rectangle:/Applications/Rectangle.app"
        "Docker:/Applications/Docker.app"
        "TablePlus:/Applications/TablePlus.app"
        "Slack:/Applications/Slack.app"
        "Zoom:/Applications/zoom.us.app"
    )
    
    for app_info in "${apps[@]}"; do
        local app_name="${app_info%:*}"
        local app_path="${app_info#*:}"
        
        if [[ -d "$app_path" ]]; then
            echo "✓ $app_name: installed" >> "$result_file"
        else
            echo "✗ $app_name: not found" >> "$result_file"
        fi
    done
}

verify_shell_configuration() {
    local result_file="$LOG_DIR/shell_check.tmp"
    
    # Check shell
    echo "ℹ Current shell: $SHELL" > "$result_file"
    
    # Check .zshrc
    if [[ -f ~/.zshrc ]]; then
        echo "✓ .zshrc exists" >> "$result_file"
        
        # Check important configurations
        local configs=("brew shellenv" "asdf.sh" "direnv hook")
        for config in "${configs[@]}"; do
            if grep -q "$config" ~/.zshrc 2>/dev/null; then
                echo "✓ $config configured" >> "$result_file"
            else
                echo "! $config not configured" >> "$result_file"
            fi
        done
    else
        echo "✗ .zshrc not found" >> "$result_file"
    fi
}

verify_package_managers() {
    local result_file="$LOG_DIR/packages_check.tmp"
    
    # Check pip
    if command -v pip &> /dev/null; then
        local pip_version=$(pip --version 2>/dev/null)
        echo "✓ pip: $pip_version" >> "$result_file"
        
        # Check for common packages
        local python_packages=("black" "flake8" "pytest" "requests" "flask")
        for pkg in "${python_packages[@]}"; do
            if pip show "$pkg" &> /dev/null; then
                echo "✓ python package: $pkg" >> "$result_file"
            else
                echo "✗ python package: $pkg" >> "$result_file"
            fi
        done
    else
        echo "✗ pip not found" >> "$result_file"
    fi
    
    # Check npm
    if command -v npm &> /dev/null; then
        local npm_version=$(npm --version 2>/dev/null)
        echo "✓ npm: $npm_version" >> "$result_file"
        
        # Check global packages
        local global_packages=$(npm list -g --depth=0 2>/dev/null | grep -E "typescript|eslint|prettier" | wc -l)
        echo "ℹ npm global packages: $global_packages found" >> "$result_file"
    else
        echo "✗ npm not found" >> "$result_file"
    fi
    
    # Check gem
    if command -v gem &> /dev/null; then
        local gem_version=$(gem --version 2>/dev/null)
        echo "✓ gem: $gem_version" >> "$result_file"
    else
        echo "✗ gem not found" >> "$result_file"
    fi
}

verify_vscode_extensions() {
    local result_file="$LOG_DIR/vscode_check.tmp"
    
    if command -v code &> /dev/null; then
        echo "✓ VS Code command available" > "$result_file"
        
        # Check for essential extensions
        local extensions=("ms-python.python" "ms-vscode.vscode-typescript-next" "ms-python.black-formatter")
        for ext in "${extensions[@]}"; do
            if code --list-extensions | grep -q "$ext"; then
                echo "✓ VS Code extension: $ext" >> "$result_file"
            else
                echo "✗ VS Code extension: $ext" >> "$result_file"
            fi
        done
    else
        echo "✗ VS Code command not available" > "$result_file"
    fi
}

# System performance check
verify_system_performance() {
    local result_file="$LOG_DIR/performance_check.tmp"
    
    # Check system resources
    local cpu_cores=$(sysctl -n hw.ncpu)
    local memory_gb=$(echo "$(sysctl -n hw.memsize) / 1024 / 1024 / 1024" | bc)
    local disk_free_gb=$(df -g / | tail -1 | awk '{print $4}')
    
    echo "ℹ System: ${cpu_cores} cores, ${memory_gb}GB RAM, ${disk_free_gb}GB free" > "$result_file"
    
    # Check for performance issues
    if [[ $memory_gb -lt 8 ]]; then
        echo "! Low memory: ${memory_gb}GB (recommend 8GB+)" >> "$result_file"
    else
        echo "✓ Memory: ${memory_gb}GB OK" >> "$result_file"
    fi
    
    if [[ $disk_free_gb -lt 20 ]]; then
        echo "! Low disk space: ${disk_free_gb}GB (recommend 20GB+)" >> "$result_file"
    else
        echo "✓ Disk space: ${disk_free_gb}GB OK" >> "$result_file"
    fi
    
    # Check for running processes that might slow things down
    local high_cpu_processes=$(ps aux | awk '{if($3 > 10) print $11}' | head -5 | wc -l)
    if [[ $high_cpu_processes -gt 0 ]]; then
        echo "! High CPU usage detected: $high_cpu_processes processes" >> "$result_file"
    else
        echo "✓ CPU usage normal" >> "$result_file"
    fi
}

# Main verification function
run_parallel_verification() {
    print_section "Running Parallel Verification"
    
    # Run all verification functions in parallel
    local pids=()
    
    verify_homebrew &
    pids+=($!)
    
    verify_languages &
    pids+=($!)
    
    verify_development_tools &
    pids+=($!)
    
    verify_applications &
    pids+=($!)
    
    verify_shell_configuration &
    pids+=($!)
    
    verify_package_managers &
    pids+=($!)
    
    verify_vscode_extensions &
    pids+=($!)
    
    verify_system_performance &
    pids+=($!)
    
    # Wait for all verification processes to complete
    print_info "Waiting for verification processes to complete..."
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
    
    print_info "Parallel verification completed!"
}

# Display results
display_results() {
    print_section "Verification Results"
    
    # Combine all results
    local total_checks=0
    local passed_checks=0
    local failed_checks=0
    local warnings=0
    
    for result_file in "$LOG_DIR"/*.tmp; do
        if [[ -f "$result_file" ]]; then
            local section_name=$(basename "$result_file" .tmp)
            print_section "${section_name^} Results"
            
            while IFS= read -r line; do
                echo "$line"
                total_checks=$((total_checks + 1))
                
                if [[ "$line" =~ ^✓ ]]; then
                    passed_checks=$((passed_checks + 1))
                elif [[ "$line" =~ ^✗ ]]; then
                    failed_checks=$((failed_checks + 1))
                elif [[ "$line" =~ ^! ]]; then
                    warnings=$((warnings + 1))
                fi
            done < "$result_file"
            
            echo ""
        fi
    done
    
    # Summary
    print_section "Summary"
    
    local success_rate=0
    if [[ $total_checks -gt 0 ]]; then
        success_rate=$((passed_checks * 100 / total_checks))
    fi
    
    echo "Total checks: $total_checks"
    echo "Passed: $passed_checks"
    echo "Failed: $failed_checks"
    echo "Warnings: $warnings"
    echo "Success rate: ${success_rate}%"
    
    # Performance summary
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo "Verification time: ${duration}s"
    
    # Recommendations
    if [[ $failed_checks -gt 0 ]]; then
        echo ""
        print_warning "Recommendations:"
        echo "1. Run setup script: ./scripts/setup-dev-optimized.sh"
        echo "2. Check individual logs in: $LOG_DIR"
        echo "3. Install missing tools manually"
    fi
    
    if [[ $warnings -gt 0 ]]; then
        echo ""
        print_info "Optimization suggestions:"
        echo "1. Configure shell: ./scripts/configure-shell.sh"
        echo "2. Free up disk space if needed"
        echo "3. Close high CPU usage applications"
    fi
    
    # Health score
    local health_score=$success_rate
    if [[ $health_score -ge 90 ]]; then
        echo ""
        print_success "🎉 Excellent! Your development environment is in great shape!"
    elif [[ $health_score -ge 75 ]]; then
        echo ""
        print_info "👍 Good! Minor issues detected but system is functional."
    elif [[ $health_score -ge 50 ]]; then
        echo ""
        print_warning "⚠️  Fair. Several issues need attention."
    else
        echo ""
        print_error "❌ Poor. Significant issues detected. Re-run setup recommended."
    fi
}

# Cleanup function
cleanup() {
    # Remove temporary files
    rm -f "$LOG_DIR"/*.tmp 2>/dev/null || true
}

# Main execution
main() {
    print_section "Optimized Installation Verification"
    
    # Initialize
    init_results
    
    # Auto-detect profile if not specified
    if [[ "$PROFILE" == "auto" ]]; then
        if [[ -f "$HOME/.config/mac-setup/config.json" ]]; then
            PROFILE=$(grep -o '"profile": "[^"]*' "$HOME/.config/mac-setup/config.json" | cut -d'"' -f4)
        else
            PROFILE="unknown"
        fi
    fi
    
    print_info "Verification profile: $PROFILE"
    print_info "Starting parallel verification..."
    
    # Run verification
    run_parallel_verification
    
    # Display results
    display_results
    
    # Cleanup
    cleanup
    
    print_info "Verification complete! Check detailed logs in: $LOG_DIR"
}

# Show usage
show_usage() {
    echo "Usage: $0 [PROFILE]"
    echo ""
    echo "Available profiles:"
    echo "  auto     - Auto-detect from previous setup"
    echo "  minimal  - Verify minimal installation"
    echo "  python   - Verify Python-focused setup"
    echo "  full     - Verify complete installation"
    echo ""
    echo "Examples:"
    echo "  $0 auto"
    echo "  $0 minimal"
    echo "  $0 full"
}

# Handle command line arguments
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

# Run main function
main "$@"
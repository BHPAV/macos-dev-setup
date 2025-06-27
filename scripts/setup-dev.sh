#!/bin/bash

# Mac Setup - Development Environment Setup Script
# This script sets up development tools, languages, and configurations

set -e

echo "🛠️  Setting up development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install it first."
        exit 1
    fi
    
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed. Please run install-homebrew.sh first."
        exit 1
    fi
    
    print_status "Prerequisites check passed."
}

# Install asdf version manager
install_asdf() {
    print_status "Installing asdf version manager..."
    if [ ! -d "$HOME/.asdf" ]; then
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
        echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
        echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
        source ~/.asdf/asdf.sh
    else
        print_status "asdf is already installed. Updating..."
        cd ~/.asdf && git pull origin master
    fi
}

# Install programming languages via asdf
install_languages() {
    print_status "Installing programming languages..."
    
    # Python
    print_status "Installing Python..."
    asdf plugin add python 2>/dev/null || print_warning "Python plugin already exists"
    asdf install python 3.11.7 2>/dev/null || print_warning "Python 3.11.7 already installed"
    asdf install python 3.12.1 2>/dev/null || print_warning "Python 3.12.1 already installed"
    asdf global python 3.12.1
    
    # Node.js
    print_status "Installing Node.js..."
    asdf plugin add nodejs 2>/dev/null || print_warning "Node.js plugin already exists"
    asdf install nodejs 20.10.0 2>/dev/null || print_warning "Node.js 20.10.0 already installed"
    asdf install nodejs 18.19.0 2>/dev/null || print_warning "Node.js 18.19.0 already installed"
    asdf global nodejs 20.10.0
    
    # Ruby
    print_status "Installing Ruby..."
    asdf plugin add ruby 2>/dev/null || print_warning "Ruby plugin already exists"
    asdf install ruby 3.2.2 2>/dev/null || print_warning "Ruby 3.2.2 already installed"
    asdf global ruby 3.2.2
    
    # Go
    print_status "Installing Go..."
    asdf plugin add golang 2>/dev/null || print_warning "Go plugin already exists"
    asdf install golang 1.21.5 2>/dev/null || print_warning "Go 1.21.5 already installed"
    asdf global golang 1.21.5
    
    # PHP
    print_status "Installing PHP..."
    asdf plugin add php 2>/dev/null || print_warning "PHP plugin already exists"
    asdf install php 8.3.0 2>/dev/null || print_warning "PHP 8.3.0 already installed"
    asdf global php 8.3.0
    
    # Java
    print_status "Installing Java..."
    asdf plugin add java 2>/dev/null || print_warning "Java plugin already exists"
    asdf install java openjdk-21 2>/dev/null || print_warning "Java openjdk-21 already installed"
    asdf global java openjdk-21
}

# Install Rust (separate from asdf)
install_rust() {
    print_status "Installing Rust..."
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
    else
        print_status "Rust is already installed. Updating..."
        rustup update
    fi
}

# Install Python packages
install_python_packages() {
    print_status "Installing Python packages..."
    pip install --upgrade pip
    
    # Core development tools
    pip install \
        black \
        flake8 \
        mypy \
        pytest \
        pytest-cov \
        ipython \
        jupyter \
        pre-commit
    
    # Data science packages
    pip install \
        pandas \
        numpy \
        matplotlib \
        seaborn \
        scikit-learn \
        plotly \
        bokeh
    
    # Web development
    pip install \
        requests \
        beautifulsoup4 \
        fastapi \
        uvicorn \
        django \
        flask \
        streamlit \
        dash
    
    # Database and async
    pip install \
        sqlalchemy \
        alembic \
        psycopg2-binary \
        redis \
        celery \
        asyncpg
    
    # AI/ML packages
    pip install \
        tensorflow \
        torch \
        transformers \
        openai \
        langchain \
        chromadb \
        sentence-transformers
}

# Install Node.js packages
install_node_packages() {
    print_status "Installing Node.js packages..."
    
    # Package managers
    npm install -g yarn pnpm
    
    # Development tools
    npm install -g \
        typescript \
        ts-node \
        nodemon \
        eslint \
        prettier \
        @types/node
    
    # Framework CLI tools
    npm install -g \
        create-react-app \
        create-next-app \
        @vue/cli \
        @angular/cli \
        expo-cli \
        gatsby-cli
    
    # Deployment tools
    npm install -g \
        netlify-cli \
        vercel \
        surge \
        pm2
    
    # Development utilities
    npm install -g \
        concurrently \
        cross-env \
        dotenv-cli \
        http-server \
        live-server \
        json-server
}

# Install Ruby gems
install_ruby_gems() {
    print_status "Installing Ruby gems..."
    gem install \
        bundler \
        rails \
        sinatra \
        rspec \
        cucumber \
        capybara \
        pry \
        pry-byebug \
        rubocop \
        reek \
        brakeman \
        bundler-audit \
        jekyll \
        sass
}

# Install Go packages
install_go_packages() {
    print_status "Installing Go packages..."
    go install \
        github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
        github.com/go-delve/delve/cmd/dlv@latest \
        github.com/cosmtrek/air@latest \
        github.com/cespare/reflex@latest \
        github.com/rakyll/hey@latest \
        github.com/tsenart/vegeta@latest \
        github.com/asciimoo/wuzz@latest \
        github.com/antonmedv/watch@latest \
        github.com/cjbassi/gotop@latest \
        github.com/bcicen/ctop@latest \
        github.com/jesseduffield/lazydocker@latest \
        github.com/jesseduffield/lazygit@latest
}

# Install Rust packages
install_rust_packages() {
    print_status "Installing Rust packages..."
    cargo install \
        ripgrep \
        fd-find \
        bat \
        exa \
        procs \
        tokei \
        hyperfine \
        bottom \
        bandwhich \
        tealdeer \
        cargo-edit \
        cargo-watch \
        cargo-audit \
        cargo-outdated \
        cargo-tree \
        cargo-expand \
        wasm-pack \
        trunk \
        mdbook
}

# Install PHP packages (simplified)
install_php_packages() {
    print_status "Installing PHP packages..."
    composer global require \
        laravel/installer \
        laravel/valet \
        symfony/console \
        symfony/var-dumper \
        phpunit/phpunit \
        friendsofphp/php-cs-fixer \
        phpstan/phpstan \
        barryvdh/laravel-ide-helper \
        barryvdh/laravel-debugbar
}

# Install development tools
install_dev_tools() {
    print_status "Installing additional development tools..."
    
    # Install Neovim configuration
    if [ ! -d "$HOME/.config/nvim" ]; then
        mkdir -p ~/.config/nvim
        git clone https://github.com/nvim-lua/kickstart.nvim.git ~/.config/nvim
    fi
    
    # Install VS Code extensions
    print_status "Installing VS Code extensions..."
    code --install-extension ms-vscode.vscode-typescript-next
    code --install-extension ms-python.python
    code --install-extension ms-python.black-formatter
    code --install-extension ms-python.flake8
    code --install-extension ms-python.mypy-type-checker
    code --install-extension ms-python.pytest-adapter
    code --install-extension ms-python.jupyter
    code --install-extension ms-python.vscode-pylance
    code --install-extension ms-vscode.vscode-json
    code --install-extension ms-vscode.vscode-yaml
    code --install-extension ms-vscode.vscode-docker
    code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension ms-vscode.vscode-git
    code --install-extension ms-vscode.vscode-git-graph
    code --install-extension ms-vscode.vscode-gitlens
    code --install-extension ms-vscode.vscode-github
    code --install-extension ms-vscode.vscode-github-pull-request
    code --install-extension ms-vscode.vscode-github-issues
}

# Setup Git configuration
setup_git() {
    print_status "Setting up Git configuration..."
    
    # Create global gitignore
    cat > ~/.gitignore_global << 'EOF'
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# nyc test coverage
.nyc_output

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# next.js build output
.next

# nuxt.js build output
.nuxt

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port
EOF

    # Configure global git settings
    git config --global core.excludesfile ~/.gitignore_global
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global push.default simple
}

# Verify installations
verify_installations() {
    print_status "Verifying installations..."
    
    # Check asdf
    if command -v asdf &> /dev/null; then
        print_status "✅ asdf is installed"
    else
        print_error "❌ asdf is not installed"
    fi
    
    # Check languages
    languages=("python" "node" "ruby" "go" "php" "java" "rustc")
    for lang in "${languages[@]}"; do
        if command -v "$lang" &> /dev/null; then
            version=$($lang --version 2>/dev/null | head -n1)
            print_status "✅ $lang is installed: $version"
        else
            print_warning "⚠️  $lang is not installed or not in PATH"
        fi
    done
}

# Main execution
main() {
    check_prerequisites
    install_asdf
    install_languages
    install_rust
    install_python_packages
    install_node_packages
    install_ruby_gems
    install_go_packages
    install_rust_packages
    install_php_packages
    install_dev_tools
    setup_git
    verify_installations
    
    print_status "✅ Development environment setup complete!"
    print_status "Next steps:"
    print_status "1. Restart your terminal or run: source ~/.zshrc"
    print_status "2. Configure your Git user info:"
    print_status "   git config --global user.name 'Your Name'"
    print_status "   git config --global user.email 'your.email@example.com'"
    print_status "3. Set up SSH keys for GitHub/GitLab"
    print_status "4. Configure your IDE settings"
    print_status "5. Test your development environment"
}

# Run main function
main "$@"

# Mac Setup Guide

This guide provides step-by-step instructions for setting up your MacBook Pro using the automation scripts in this repository.

## Prerequisites

Before starting the setup process, ensure you have:

- A MacBook Pro with macOS Sonoma (14.0) or later
- Administrator privileges
- Internet connection
- Apple ID (for iCloud and App Store)
- At least 50GB of free disk space

## Quick Setup

### 1. Clone the Repository

```bash
git clone <your-repo-url> ~/mac-setup
cd ~/mac-setup
```

### 2. Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### 3. Run the Setup Scripts

Execute the scripts in the following order:

```bash
# Install Homebrew and essential tools
./scripts/install-homebrew.sh

# Configure shell environment (minimal)
./scripts/configure-shell.sh

# Optional: Enhanced shell with Oh My Zsh (adds complexity)
# ./scripts/setup-shell-enhanced.sh

# Set up development environment
./scripts/setup-dev.sh
```

## Detailed Setup Process

### Phase 1: Initial System Configuration

#### 1.1 Apple ID and iCloud Setup
1. Open System Preferences > Apple ID
2. Sign in with your Apple ID
3. Enable iCloud services:
   - iCloud Drive
   - Photos
   - Contacts
   - Calendar
   - Reminders
   - Notes
   - Keychain

#### 1.2 System Preferences
1. **General**
   - Set computer name
   - Configure appearance (Light/Dark mode)
   - Set accent color

2. **Desktop & Screen Saver**
   - Choose desktop wallpaper
   - Configure screen saver
   - Set screen saver activation time

3. **Dock**
   - Run: `./configs/system/dock-settings.sh`
   - Or configure manually in System Preferences

4. **Mission Control**
   - Configure Spaces
   - Set up Hot Corners
   - Configure keyboard shortcuts

5. **Security & Privacy**
   - Run: `./configs/system/security.sh`
   - Configure Touch ID
   - Set up FileVault
   - Configure firewall

### Phase 2: Development Environment Setup

#### 2.1 Command Line Tools
The `install-homebrew.sh` script will install:
- Xcode Command Line Tools
- Homebrew package manager
- Essential command line utilities

#### 2.2 Shell Configuration
The `configure-shell.sh` script will add:
- Homebrew to PATH
- asdf version manager
- direnv environment loader
- Essential aliases (git, python, docker)
- Python virtual environment helpers

For advanced users, `setup-shell-enhanced.sh` optionally adds:
- Oh My Zsh framework
- Additional plugins and themes
- Extended aliases and functions

#### 2.3 Programming Languages
The `setup-dev.sh` script will install:
- Python (3.11.7, 3.12.1)
- Node.js (18.19.0, 20.10.0)
- Ruby (3.2.2)
- Go (1.21.5)
- PHP (8.3.0)
- Java (OpenJDK 21)
- Rust (latest)

#### 2.4 Development Tools
- VS Code with extensions
- Neovim configuration
- Git configuration
- Database tools
- Container tools

### Phase 3: Application Installation

#### 3.1 Essential Applications
Review and customize the application lists:
- `apps/essential-apps.txt` - Core applications
- `apps/dev-apps.txt` - Development tools
- `apps/productivity-apps.txt` - Productivity tools

#### 3.2 Manual Installation
Some applications require manual installation:
1. **Adobe Creative Cloud** - Download from Adobe website
2. **Microsoft Office** - Download from Microsoft website
3. **Xcode** - Install from App Store
4. **Android Studio** - Download from Google website

### Phase 4: Configuration

#### 4.1 Git Configuration
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### 4.2 SSH Keys
```bash
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
ssh-add ~/.ssh/id_rsa
```

#### 4.3 VS Code Configuration
1. Copy settings from `configs/vscode/settings.json`
2. Install extensions from `configs/vscode/extensions.txt`

#### 4.4 Shell Configuration
1. Copy shell configs from `configs/shell/`
2. Customize aliases and functions as needed

### Phase 5: Testing and Validation

#### 5.1 Verify Installations
```bash
# Check Homebrew
brew doctor

# Check programming languages
python --version
node --version
ruby --version
go version
php --version
java --version
rustc --version

# Check development tools
git --version
docker --version
code --version
```

#### 5.2 Test Development Environment
1. Create a test project
2. Test Git workflow
3. Test VS Code functionality
4. Test terminal and shell features

## Customization

### Application Lists
Edit the application lists in the `apps/` directory to match your preferences:
- Remove applications you don't need
- Add applications specific to your workflow
- Organize by category or priority

### Configuration Files
Customize the configuration files in the `configs/` directory:
- Modify VS Code settings
- Update shell aliases
- Configure Git preferences
- Adjust system settings

### Scripts
Modify the setup scripts to:
- Add additional tools
- Change default settings
- Include custom configurations
- Add project-specific setup

## Troubleshooting

### Common Issues

#### Homebrew Installation Fails
```bash
# Check Xcode Command Line Tools
xcode-select --install

# Reset Homebrew
brew doctor
```

#### Shell Configuration Issues
```bash
# Reload shell configuration
source ~/.zshrc

# Check Oh My Zsh installation
ls -la ~/.oh-my-zsh
```

#### Permission Issues
```bash
# Fix permissions
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/sbin
chmod u+w /usr/local/bin /usr/local/lib /usr/local/sbin
```

#### VS Code Issues
```bash
# Reset VS Code settings
rm -rf ~/Library/Application\ Support/Code/User/settings.json
```

### Getting Help

1. Check the troubleshooting guide in `docs/troubleshooting.md`
2. Review script output for error messages
3. Check system logs for issues
4. Consult official documentation for tools

## Maintenance

### Regular Updates
```bash
# Update Homebrew
brew update && brew upgrade

# Update shell plugins
omz update

# Update VS Code extensions
code --list-extensions | xargs -n 1 code --install-extension
```

### Backup Configuration
```bash
# Backup configuration files
cp -r ~/mac-setup ~/mac-setup-backup-$(date +%Y%m%d)
```

### Cleanup
```bash
# Clean Homebrew
brew cleanup

# Remove unused applications
brew uninstall --ignore-dependencies $(brew deps --installed --tree | grep -v "├──\|└──" | sort | uniq)
```

## Next Steps

After completing the setup:

1. **Configure your workflow** - Set up project directories and workflows
2. **Set up backups** - Configure Time Machine or other backup solutions
3. **Install additional tools** - Add tools specific to your projects
4. **Customize further** - Fine-tune settings based on your preferences
5. **Document changes** - Keep track of customizations for future setups

## Support

For issues and questions:
1. Check the troubleshooting guide
2. Review script documentation
3. Search existing issues
4. Create a new issue with detailed information

---

**Note**: This setup is designed to be comprehensive but may need customization for your specific needs. Always review and test configurations before applying them to production systems. 
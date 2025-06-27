# Mac Setup Configuration

This repository contains all the configuration files and scripts needed to quickly set up a new MacBook Pro with your preferred settings, applications, and development environment.

## Project Structure

```
mac-setup/
├── README.md                 # This file
├── setup-plan.md            # Detailed setup plan and checklist
├── scripts/                 # Automation scripts
│   ├── install-homebrew.sh  # Homebrew installation
│   ├── install-apps.sh      # Application installation
│   ├── setup-shell.sh       # Shell configuration
│   └── setup-dev.sh         # Development environment setup
├── configs/                 # Configuration files
│   ├── shell/               # Shell configurations
│   │   ├── .zshrc          # Zsh configuration
│   │   └── .zsh_aliases    # Custom aliases
│   ├── git/                 # Git configurations
│   │   ├── .gitconfig      # Global git config
│   │   └── .gitignore_global # Global gitignore
│   ├── vscode/              # VS Code settings
│   │   ├── settings.json    # VS Code settings
│   │   └── extensions.txt   # VS Code extensions list
│   └── system/              # System preferences
│       ├── dock-settings.sh # Dock configuration
│       └── security.sh      # Security settings
├── apps/                    # Application lists
│   ├── essential-apps.txt   # Essential applications
│   ├── dev-apps.txt         # Development tools
│   └── productivity-apps.txt # Productivity tools
└── docs/                    # Documentation
    ├── setup-guide.md       # Step-by-step setup guide
    └── troubleshooting.md   # Common issues and solutions
```

## Quick Start

1. Clone this repository to your new Mac
2. Run the setup scripts in order:
   ```bash
   chmod +x scripts/*.sh
   ./scripts/install-homebrew.sh
   ./scripts/install-apps.sh
   ./scripts/setup-shell.sh
   ./scripts/setup-dev.sh
   ```
3. Follow the detailed setup guide in `docs/setup-guide.md`

## Features

- **Automated Installation**: Scripts to install Homebrew, applications, and development tools
- **Shell Configuration**: Pre-configured Zsh with Oh My Zsh, themes, and aliases
- **Git Setup**: Global git configuration and useful aliases
- **VS Code Configuration**: Settings and extensions for development
- **System Preferences**: Dock settings, security configurations, and more
- **Application Management**: Curated lists of essential, development, and productivity apps

## Prerequisites

- macOS (tested on macOS Sonoma and later)
- Administrator privileges
- Internet connection

## Contributing

When you make changes to your setup, update the corresponding configuration files and scripts in this repository to keep it current for future installations.

## License

This project is for personal use. Feel free to adapt it for your own needs. 
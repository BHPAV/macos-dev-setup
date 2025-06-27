# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a macOS development environment automation repository designed to quickly set up a new Mac with development tools and configurations following a "minimal-first" approach. It focuses on essentials for Python, SQLite, Neo4j, Flask, and ML/RL R&D work.

## Common Commands

### Testing and Validation

```bash
# Lint shell scripts
find . -type f -name "*.sh" -exec shellcheck {} \;

# Lint YAML files
yamllint .

# Check script permissions
find ./scripts -type f -name "*.sh" ! -perm -u=x

# Validate Brewfile
brew bundle check --file=scripts/Brewfile
```

### Main Setup Scripts

```bash
# Install Homebrew and core applications
./scripts/install-homebrew-minimal.sh

# Configure shell environment (minimal)
./scripts/configure-shell.sh

# Configure Git
./scripts/setup-git.sh

# Set up GitHub SSH and CLI
./scripts/setup-github.sh

# Full development environment setup
./scripts/setup-dev.sh

# Optional: Enhanced shell with Oh My Zsh
# ./scripts/setup-shell-enhanced.sh
```

## Repository Architecture

The repository follows a modular structure with clear separation of concerns:

- **Automation Scripts** (`/scripts/`): Self-contained bash scripts that perform specific setup tasks. Each script is designed to be idempotent and can be run independently.

- **Configuration Files** (`/configs/`): Dotfiles and configuration templates organized by tool/service. These are applied by the corresponding setup scripts.

- **Application Lists** (`/apps/`): Text files categorizing applications by purpose, making it easy to customize installations.

- **Homebrew Management**: Central `Brewfile` defines all packages and applications. The minimal setup focuses on Day 1 essentials, with optional additions commented out.

## Key Design Principles

1. **Minimal First**: Start with core tools only, avoiding bloat. Additional tools are commented in Brewfile for easy activation.

2. **Security by Default**: All scripts implement security best practices:
   - ED25519 SSH keys
   - Secure Git configurations
   - macOS Keychain integration
   - 1Password SSH agent support

3. **Idempotent Scripts**: All setup scripts can be run multiple times safely without causing issues.

4. **CI/CD Integration**: GitHub Actions workflows validate:
   - Shell script syntax with ShellCheck
   - YAML file formatting
   - Script permissions
   - Brewfile validity
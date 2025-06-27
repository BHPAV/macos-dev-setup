# macOS Development Environment Setup

A minimal-first approach to setting up a macOS development environment, focused on Python, SQLite, Neo4j, Flask, and ML/RL R&D work.

## 🚀 Quick Start

```bash
# Clone the repository
git clone git@github.com:BHPAV/macos-dev-setup.git
cd macos-dev-setup

# Install Homebrew and core applications
./scripts/install-homebrew-minimal.sh

# Configure Git
./scripts/setup-git.sh

# Set up GitHub SSH and CLI
./scripts/setup-github.sh
```

## 📦 What's Included

### Core Development Tools (Day 1 Essentials)

- **Browser**: Arc (lightweight Chromium with excellent profile isolation)
- **Security**: 1Password (password management with SSH agent support)
- **Cloud Storage**: OneDrive (Microsoft ecosystem integration)
- **Communication**: Slack, Zoom
- **Development**:
  - VS Code (primary editor)
  - iTerm2 (terminal emulator)
  - Docker (containerization)
  - Neo4j Desktop (graph database)
  - TablePlus (database GUI)
  - Insomnia (API testing)
- **Window Management**: Rectangle

### Quality-of-Life Utilities

- Alfred (advanced Spotlight replacement)
- Bartender (menu bar management)
- Amphetamine (prevent sleep)
- iStat Menus (system monitoring)
- CleanShot X (screenshots/recording)

### Development Stack Additions

- DBeaver Lite (universal DB GUI)
- Neo4j Bloom (graph visualization)
- TablePlus CLI
- Development Environment Tools:
  - asdf (version management)
  - direnv (environment variables)
  - make (build automation)

## 📂 Repository Structure

```
mac-setup/
├── apps/                    # Application lists
│   ├── dev-apps.txt        # Development tools
│   ├── essential-apps.txt  # Core applications
│   └── productivity-apps.txt
├── configs/                 # Configuration files
│   ├── git/
│   ├── shell/
│   ├── system/
│   └── vscode/
├── docs/                    # Documentation
├── scripts/                 # Setup scripts
│   ├── Brewfile            # Homebrew packages
│   ├── install-homebrew-minimal.sh
│   ├── setup-git.sh
│   └── setup-github.sh
└── setup-plan.md           # Setup strategy
```

## 🛠 Setup Scripts

1. **`install-homebrew-minimal.sh`**
   - Installs Homebrew
   - Sets up core applications via Brewfile
   - Configures basic system settings

2. **`setup-git.sh`**
   - Configures Git identity
   - Sets up useful aliases
   - Configures secure defaults

3. **`setup-github.sh`**
   - Generates SSH keys
   - Configures GitHub CLI
   - Sets up SSH authentication

## 🔒 Security Features

- SSH key generation with ED25519
- Secure Git defaults
- macOS Keychain integration
- 1Password SSH agent support

## 🎯 Design Philosophy

1. **Minimal First**: Start with core tools, add utilities only when needed
2. **Reproducible**: Automated setup via Homebrew and scripts
3. **Secure**: Best practices for Git, SSH, and system security
4. **Efficient**: Optimized for Python, SQLite, Neo4j, and Flask development

## 📚 Additional Resources

- [Arc Browser Documentation](https://arc.net/docs)
- [VS Code Python Setup](https://code.visualstudio.com/docs/python/python-tutorial)
- [Neo4j Desktop Guide](https://neo4j.com/developer/neo4j-desktop/)
- [GitHub CLI Manual](https://cli.github.com/manual/)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by various macOS setup guides and best practices
- Built with a focus on minimal, efficient development workflows
- Community feedback and contributions welcome 
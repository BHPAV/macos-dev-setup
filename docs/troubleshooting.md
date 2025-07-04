# Mac Setup - Troubleshooting Guide

## Common Installation Issues

### Homebrew Tap Warnings

When running the installation script, you may see warnings about taps:

```
Warning: Tap homebrew/cask already tapped.
Warning: Tap homebrew/core already tapped.
Warning: Tap homebrew/bundle already tapped.
```

**Solution**: These warnings are harmless and can be ignored. As of Homebrew 4.0+, these taps are built-in and no longer need to be explicitly tapped.

### Docker Installation Fails

**Issue**: Docker installation fails with permission errors, xattr errors, or "target already exists" error.

**Possible Causes**:
1. Docker Desktop is already installed outside of Homebrew
2. Permissions issue with existing Docker.app
3. xattr metadata conflicts

**Solutions**:

1. **Use the fix-docker.sh script** (recommended):
   ```bash
   ./scripts/fix-docker.sh
   ```

2. **Manual fix** - Check if Docker is already installed:
   ```bash
   ls -la /Applications/Docker.app
   ```

3. If Docker exists and you want to manage it with Homebrew:
   ```bash
   # First quit Docker Desktop if running
   osascript -e 'quit app "Docker"'
   
   # Remove existing installation
   sudo rm -rf /Applications/Docker.app
   rm -rf ~/Library/Group\ Containers/group.com.docker
   rm -rf ~/Library/Containers/com.docker.docker
   
   # Reinstall via Homebrew
   brew install --cask docker
   ```

4. If you prefer to keep your existing Docker installation:
   - Remove `cask "docker"` from the Brewfile
   - Continue using your existing Docker Desktop

5. **Alternative**: Download directly from [Docker's website](https://www.docker.com/products/docker-desktop/)

### Amphetamine Not Found

**Issue**: `Error: Cask 'amphetamine' is unavailable: No Cask with this name exists.`

**Solution**: Amphetamine is no longer available as a Homebrew cask. Install it directly from the Mac App Store:
1. Open Mac App Store
2. Search for "Amphetamine"
3. Install the free app

Alternatively, you can use `caffeine` as a replacement:
```bash
brew install --cask caffeine
```

### Shell Configuration Not Applied

**Issue**: After installation, tools like `asdf` and `direnv` don't work.

**Solution**: 

1. **Use the configure-shell.sh script** (recommended):
   ```bash
   ./scripts/configure-shell.sh
   source ~/.zshrc
   ```

2. **Manual configuration** - Add to your ~/.zshrc:
   ```bash
   # Homebrew
   eval "$(/opt/homebrew/bin/brew shellenv)"
   
   # asdf
   . /opt/homebrew/opt/asdf/libexec/asdf.sh
   
   # direnv
   eval "$(direnv hook zsh)"
   ```

3. **Alternative** - Use the provided shell configuration:
   ```bash
   echo "source ~/Dev/mac-setup/configs/shell/zshrc" >> ~/.zshrc
   source ~/.zshrc
   ```

### Homebrew PATH Not Set

**Issue**: `brew` command not found after installation.

**Solution** (for Apple Silicon Macs):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Solution** (for Intel Macs):
```bash
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

## Verification Steps

To verify your installation:

1. Check Homebrew:
   ```bash
   brew --version
   brew doctor
   ```

2. Check installed packages:
   ```bash
   brew list
   brew list --cask
   ```

3. Check failed installations:
   ```bash
   brew bundle check --file=scripts/Brewfile
   ```

4. Check shell configuration:
   ```bash
   echo $PATH | grep -q "/opt/homebrew/bin" && echo "✓ Homebrew in PATH" || echo "✗ Homebrew not in PATH"
   command -v asdf &> /dev/null && echo "✓ asdf available" || echo "✗ asdf not available"
   command -v direnv &> /dev/null && echo "✓ direnv available" || echo "✗ direnv not available"
   ```

## Manual Fixes

### Re-run Failed Installations

To retry installing only the failed packages:

```bash
cd ~/Dev/mac-setup
brew bundle --file=scripts/Brewfile
```

### Install Individual Packages

If specific packages fail, install them individually:

```bash
# For formulae
brew install package-name

# For casks
brew install --cask application-name
```

### Clean Up Homebrew

If you're having issues, try cleaning up:

```bash
brew cleanup
brew doctor
```

## Known Issues

### macOS Pre-release Warning

**Issue**: "You are using macOS X.X. We do not provide support for this pre-release version."

**Solution**: This warning appears when using macOS beta versions. The installation usually succeeds despite the warning. If you encounter issues:
- Report them to Homebrew's GitHub repository
- Consider downgrading to a stable macOS release for production environments

### Homebrew Bundle Tap Deprecated

**Issue**: "Error: homebrew/bundle was deprecated. This tap is now empty."

**Solution**: The `brew bundle` command is now built into Homebrew. The Brewfile has been updated to remove this tap reference.

## Getting Help

If you continue to experience issues:

1. Check Homebrew's official documentation: https://docs.brew.sh
2. Search for specific error messages
3. Check if the package exists: `brew search package-name`
4. View package info: `brew info package-name` or `brew info --cask application-name`
5. Run the verification script: `./scripts/verify-installation.sh`
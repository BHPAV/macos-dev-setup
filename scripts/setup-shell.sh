#!/bin/bash

# Mac Setup - Shell Configuration Script
# This script sets up Zsh with Oh My Zsh and custom configurations

set -e

echo "🐚 Setting up shell environment..."

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

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_status "Oh My Zsh is already installed. Updating..."
    zsh -c "source ~/.zshrc && omz update"
fi

# Install additional Zsh plugins
print_status "Installing Zsh plugins..."

# Install zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install zsh-completions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
fi

# Install fzf-tab
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fzf-tab" ]; then
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
fi

# Install zsh-nvm
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" ]; then
    git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm
fi

# Install pyenv-lazy
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/pyenv-lazy" ]; then
    git clone https://github.com/davidparsson/zsh-pyenv-lazy.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/pyenv-lazy
fi

# Create custom Zsh configuration
print_status "Creating custom Zsh configuration..."

cat > ~/.zshrc << 'EOF'
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    fzf-tab
    zsh-nvm
    pyenv-lazy
    docker
    kubectl
    helm
    terraform
    aws
    brew
    macos
    history
    extract
    sudo
    copypath
    dirhistory
    web-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Load custom aliases
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# Load custom functions
if [ -f ~/.zsh_functions ]; then
    source ~/.zsh_functions
fi

# Initialize starship prompt (if installed)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Initialize direnv (if installed)
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Initialize asdf (if installed)
if [ -f ~/.asdf/asdf.sh ]; then
    source ~/.asdf/asdf.sh
fi

# Initialize pyenv (if installed)
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi

# Initialize rbenv (if installed)
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init -)"
fi

# Initialize nodenv (if installed)
if command -v nodenv &> /dev/null; then
    eval "$(nodenv init -)"
fi

# Initialize goenv (if installed)
if command -v goenv &> /dev/null; then
    eval "$(goenv init -)"
fi

# Set up fzf
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Set up bat
if command -v bat &> /dev/null; then
    export BAT_THEME="TwoDark"
fi

# Set up environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R"

# Set up PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"

# Set up history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Set up completion
autoload -U compinit
compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# Create custom aliases file
print_status "Creating custom aliases..."

cat > ~/.zsh_aliases << 'EOF'
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# List directory contents
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias lsd='ls -la | grep "^d"'

# Git aliases
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gs='git status'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gf='git fetch'
alias gm='git merge'
alias grb='git rebase'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs'

# Kubernetes aliases
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# Development aliases
alias py='python'
alias py3='python3'
alias pip='pip3'
alias node='node'
alias npm='npm'
alias npx='npx'
alias yarn='yarn'
alias go='go'
alias rust='rustc'
alias cargo='cargo'

# System aliases
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias diskusage='df -h'
alias folder='du -sh'

# Network aliases
alias myip='curl http://ipecho.net/plain; echo'
alias ping='ping -c 5'
alias ports='netstat -tulanp'

# Utility aliases
alias weather='curl wttr.in'
alias speedtest='speedtest-cli'
alias youtube-dl='yt-dlp'

# macOS specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Quick access to config files
alias zshrc='nvim ~/.zshrc'
alias zshaliases='nvim ~/.zsh_aliases'
alias gitconfig='nvim ~/.gitconfig'
alias vimrc='nvim ~/.vimrc'
alias nvimrc='nvim ~/.config/nvim/init.vim'

# Development shortcuts
alias dev='cd ~/Dev'
alias projects='cd ~/Projects'
alias downloads='cd ~/Downloads'
alias desktop='cd ~/Desktop'
alias documents='cd ~/Documents'

# SSH aliases
alias sshconfig='nvim ~/.ssh/config'
alias sshkey='ssh-keygen -t rsa -b 4096 -C "$(git config user.email)"'

# Backup aliases
alias backup='rsync -av --delete ~/ /Volumes/Backup/'
alias sync='rsync -av ~/ /Volumes/Sync/'

# Package manager aliases
alias brewup='brew update && brew upgrade && brew cleanup'
alias masup='mas upgrade'
alias pipup='pip list --outdated --format=freeze | grep -v "^\-e" | cut -d = -f 1 | xargs -n1 pip install -U'

# Function aliases
alias mkcd='function _mkcd(){ mkdir -p "$1"; cd "$1"; }; _mkcd'
alias cdf='function _cdf(){ cd "$(find . -type d -name "$1" | head -1)"; }; _cdf'
alias findf='function _findf(){ find . -name "*$1*"; }; _findf'
alias grepf='function _grepf(){ grep -r "$1" .; }; _grepf'
EOF

# Create custom functions file
print_status "Creating custom functions..."

cat > ~/.zsh_functions << 'EOF'
# Create a new directory and enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Change to a directory and list its contents
cdl() {
    cd "$1" && ls -la
}

# Create a backup of a file
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a new Python virtual environment
mkvenv() {
    python3 -m venv "$1" && source "$1/bin/activate"
}

# Git functions
gac() {
    git add . && git commit -m "$1"
}

gacp() {
    git add . && git commit -m "$1" && git push
}

gundo() {
    git reset --soft HEAD~1
}

gclean() {
    git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
}

# Docker functions
dclean() {
    docker system prune -f
    docker volume prune -f
    docker network prune -f
}

dstop() {
    docker stop $(docker ps -q)
}

# Kubernetes functions
kns() {
    kubectl config set-context --current --namespace="$1"
}

kctx() {
    kubectl config use-context "$1"
}

# System functions
weather() {
    curl wttr.in/"$1"
}

speedtest() {
    speedtest-cli --simple
}

# Development functions
serve() {
    python3 -m http.server "$1"
}

# Network functions
port() {
    lsof -i :"$1"
}

# Utility functions
path() {
    echo $PATH | tr ':' '\n'
}

# macOS functions
flushdns() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}

# Backup functions
backup_home() {
    rsync -av --delete ~/ /Volumes/Backup/home_backup/
}

# Package management functions
update_all() {
    brewup
    masup
    pipup
}
EOF

# Install Powerlevel10k theme
print_status "Installing Powerlevel10k theme..."
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Make scripts executable
chmod +x ~/.zsh_aliases
chmod +x ~/.zsh_functions

print_status "✅ Shell setup complete!"
print_status "Next steps:"
print_status "1. Restart your terminal or run: source ~/.zshrc"
print_status "2. Configure Powerlevel10k theme: p10k configure"
print_status "3. Run: ./scripts/setup-dev.sh" 
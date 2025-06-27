# Zsh Configuration File
# This is a template - customize as needed

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    docker
    kubectl
    helm
    terraform
    aws
    brew
    macos
)

source $ZSH/oh-my-zsh.sh

# Load custom aliases and functions
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

if [ -f ~/.zsh_functions ]; then
    source ~/.zsh_functions
fi

# Customize your configuration here 
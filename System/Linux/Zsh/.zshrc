# History
HISTSIZE=1000
HIST_STAMPS="yyyy-mm-dd"
SAVEHIST=1000
setopt appendhistory
bindkey -e

autoload -Uz compinit
compinit
setopt no_auto_remove_slash

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=$HOME/Cyb/shell/oh-my-zsh
ZSH_THEME="cyb"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

DISABLE_AUTO_UPDATE="false"
export UPDATE_ZSH_DAYS=90

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=de_DE.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Run SSH Agent and add key 10h
if [ -f ~/.ssh/id_rsa ] ; then
  eval `ssh-agent -s`
  ssh-add -t 36000 ~/.ssh/id_rsa
fi

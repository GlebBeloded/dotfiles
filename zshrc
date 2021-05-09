# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# Enable colors and change prompt:
autoload -U colors && colors

# Autocompitions
autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vim mode bindings
source ~/.config/zsh/vim_bindings.zsh
# aliases
source ~/.config/zsh/aliases.zsh
# command line prompt
source ~/.config/zsh/prompt.zsh
source ~/.config/zsh/zsh-syntax-highlighting-master/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions-master/zsh-autosuggestions.zsh

# work stuff
if [ -f ~/.work.zsh ];then
  source ~/.work.zsh
fi


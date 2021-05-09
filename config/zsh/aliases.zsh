#!/bin/zsh

# Use neovim for vim if present.
command -v nvim >/dev/null && alias vim="nvim" vimdiff="nvim -d"

# everyday use aliases
alias \
  cp="cp -iv" \
  mv="mv -iv" \
  rm="rm -vI" \
  mkd="mkdir -pv" \
  v=nvim \
  ls='exa --icons -a --group-directories-first --color=always' \
  tree='ls --tree' \
  cat='bat --theme="TwoDark" --style="changes" --paging=never --color=always' \
  cl="tr -d '\n' | xsel -b"

# Pretty colors
alias \
  grep="grep --color=auto" \
  less="less -r" \
  diff="diff --color=auto"

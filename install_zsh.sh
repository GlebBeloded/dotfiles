#!/bin/sh

ZSH_DIR=~/.config/zsh
HISTFILE=~/.cache/zsh/history
SCRIPT_DIR=$(dirname $(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")"))

# check if zsh directory exists
if [ ! -d $ZSH_DIR ]; then
  mkdir -p $ZSH_DIR
fi

# check if history file exists
if [ ! -f $HISTFILE ]; then
  mkdir -p "$(dirname $HISTFILE)"
  touch $HISTFILE
fi

cd $ZSH_DIR || exit 1

curl -fsSL https://github.com/jeffreytse/zsh-vi-mode/raw/master/zsh-vi-mode.zsh >$ZSH_DIR/vim_bindings.zsh
curl -fsSL https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz | tar -zxf -
curl -fsSL https://github.com/zsh-users/zsh-autosuggestions/archive/master.tar.gz | tar -zxf -
npm install --silent -g spaceship-prompt

cp $SCRIPT_DIR/config/zsh/* ~/.config/zsh

cp $SCRIPT_DIR/zshrc ~/.zshrc
cp $SCRIPT_DIR/zprofile ~/.zprofile

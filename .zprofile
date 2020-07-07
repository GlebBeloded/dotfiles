#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"

# zsh history 
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
HISTSIZE=10000
SAVEHIST=10000

# path to rust exectuables
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export PATH=$PATH:$CARGO_HOME/bin

# golang environment
export GOPATH=${XDG_DATA_HOME:-$HOME/.local/share}/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export GO111MODULE=on

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"

# just in case some app needs it
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


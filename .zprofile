#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

# path to rust exectuables
export PATH="$HOME/.cargo/bin:$PATH"

# golang environment
export GOPATH=$HOME/go
PATH=$PATH:~/go/bin 
PATH=$PATH:~/.local/bin
PATH=$PATH:/usr/local/go/bin
export PATH
export GOBIN=$GOPATH/bin
export GO111MODULE=on

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"

# just in case because of weird autocompletion bugs
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

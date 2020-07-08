#!/bin/bash
#script to install all the basic stuff that I need

#crash on error
set -e

#get path to script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# export DIR variable for install script
export DIR

# run script as root first, then run it as normal user
if [ $EUID != 0 ]; then
  _USER=${USER}
  export _USER
  sudo -E "$0" "$@"
fi
 
# installs which require root priveleges
if [ $EUID == 0 ]; then
  # Ensure the base-devel package group is installed in full 
  pacman -S --needed base-devel --noconfirm
  pacman -Syu --noconfirm

  # Install Desktop environment stuff
  pacman -S --noconfirm i3-wm unclutter picom rofi pulseaudio

  # Install programming stuff
  # C, C++, Python, Go, Rust
  pacman -S --noconfirm gcc make cmake python python-pip go rust
  
  # Miscallenious stuff
  pacman -S --noconfirm neovim zsh jq code docker git man
  pacman -S --noconfirm --asdeps xclip xsel

  # Install browser
  pacman -S --noconfirm firefox
  # install all firefox optional dependencies to get media codecs
  pacman -S --asdeps --noconfirm hunspell-en_US 
  
  # Install media stuff
  pacman -S --noconfirm feh mpv newsboat zathura zathura-pdf-mupdf zathura-djvu

  # dependencies for image/video previews in lf
  pacman -S --noconfirm poppler ffmpegthumbnailer w3m imagemagick

  # fonts that I use
  pacman -S --noconfirm terminus-font ttf-font-awesome ttf-cascadia-code

  # simple terminal
  git clone https://github.com/GlebBeloded/st.git /tmp/st
  cd /tmp/st
  make install
  cd $DIR

  # zsh syntax highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /tmp/zsh-syntax
  cd /tmp/zsh-syntax && make install
  cd $DIR

  # make zsh default for user
  usermod --shell /usr/bin/zsh $_USER
  # make zsh default for root
  usermod --shell /usr/bin/zsh $USER

  # move .zshrc to root home, because I want root prompt to be the same as main prompt
  /usr/bin/cp $DIR/.zshrc /root/
fi

# make sure all neccessary directories exist
if [ $EUID != 0 ];then 
  # Ensure ~/.local exists
  if [ ! -d ~/.local ];then
    mkdir ~/.local
    if [ ! -d ~/.local/bin ];then
        mkdir ~/.local/bin
    fi
    if [ ! -d ~/.local/share ];then
      mkdir ~/.local/share
    fi
  fi

  # Ensure ~/.config exists
  if [ ! -d ~/.config ];then
    mkdir ~/.config
  fi

  if [ ! -d ~/.cache ];then
    mkdir ~/.cache
    if [ ! -d ~/.cache/zsh ];then
      mkdir ~/.cache/zsh
    fi
  fi
fi

# User space installs
if [ $EUID != 0 ]; then
  # top bar
  $DIR/aur_install.sh https://aur.archlinux.org/polybar.git /tmp/polybar
  # top replacement
  $DIR/aur_install.sh https://aur.archlinux.org/ytop.git /tmp/ytop
  # font awesome
  $DIR/aur_install.sh https://aur.archlinux.org/ttf-font-awesome-4.git /tmp/fa4

  # install swallow script for i3
  git clone https://github.com/jamesofarrell/i3-swallow.git /tmp/swallow
  /usr/bin/cp /tmp/swallow/swallow ~/.local/bin/

  #install vscode extensions
  while read ext; do
    code --install-extension $ext
  done < $DIR/config/Code\ -\ OSS/extensions

  # lf and stuff which has to do with image previews
  # install lf
  git clone https://github.com/Provessor/lf.git /tmp/lf
  cd /tmp/lf
  go build -o ~/.local/bin/lf
  cd $DIR
  pip3 install ueberzug Pillow i3ipc

  # zsh history file
  touch ~/.cache/zsh/history
fi

# move actual dotfiles
if [ $EUID != 0 ];then
  # move zshrc and zprofile home 
  /usr/bin/cp $DIR/{.zprofile,.zshrc} ~

  # xorg stuff
  /usr/bin/cp $DIR/{.Xresources,.xprofile,.xinitrc} ~
  # dotfiles
  /usr/bin/cp -r $DIR/config/* ~/.config/

  # move some programs and configs to ~/.local
  /usr/bin/cp -r $DIR/local/bin/* ~/.local/bin/
  /usr/bin/cp -r $DIR/local/share/* ~/.local/share/
fi

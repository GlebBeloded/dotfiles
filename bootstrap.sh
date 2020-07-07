#!/bin/bash
#script to install all the basic stuff that I need

#crash on error
set -e
#user home path before we shitch to root
#get path to script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#if not root get root rights and rerun the script with usrhome enviroment variable 
if [ $EUID != 0 ]; then
    USRHOME=${HOME}
    _USER=${USER}
    export USRHOME
    export _USER
    sudo -E "$0" "$@"
    exit $?
fi

# Ensure ~/.local exists
if ![-f $USRHOME/.local];then
  mkdir $USRHOME/.local
fi

# Ensure ~/.config exists
if ![-f $USRHOME/.config];then
  mkdir $USRHOME/.config
fi

# Ensure the base-devel package group is installed in full 
pacman -S --needed base-devel --noconfirm
pacman -Syu --noconfirm

# Install Desktop environment stuff
pacman -S --noconfirm i3-wm polybar unclutter picom rofi pulseaudio

# Install fonts I use
pacman -S --noconfirm nerd-fonts-complete

# Install programming stuff
# C, C++, Python, Go, Rust
pacman -S --noconfirm gcc make cmake python python-pip go rust
# Miscallenious stuff
pacman -S --noconfirm nvim zsh jq code docker ytop

# Install browser
pacman -S --noconfirm firefox
# install all firefox optional dependencies to get media codecs
pacman -S --asdeps $(pactree -l firefox)
# Install media stuff
pacman -S --noconfirm feh mpv newsboat zathura zathura-pdf-mupdf zathura-djvu

# install swallow script for i3
git clone https://github.com/jamesofarrell/i3-swallow.git /tmp/swallow
/usr/bin/cp --parents /tmp/swallow/swallow $USRHOME/.local/bin/

#install vscode extensions
while read ext; do
  code --install-extnesion $ext
done < $DIR/config/Code/extensions

# simple terminal
git clone https://github.com/GlebBeloded/st.git /tmp/st
cd /tmp/st
make install
cd $DIR

# zsh related stuff
# move zshrc and zprofile home 
/usr/bin/cp $DIR/{.zprofile, .zshrc} $USRHOME
# also move .zshrc to root home, because I want root prompt to be the same as main prompt
/usr/bincp $DIR/.zshrc /root/
#make zshell default
usermod --shell /usr/bin/zsh $_USER
# zsh history file
mkdir -p $USERHOME/.cache/zsh
touch $USERHOME/.cache/zsh/history
# zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /tmp/zsh-syntax
cd /tmp/zsh-syntax && make install
cd $DIR

# lf and stuff which has to do with image previews
# install lf
git clone https://github.com/Provessor/lf.git /tmp/lf
cd /tmp/lf
go build -o $USRHOME/.local/bin/lf
cd $DIR
# dependencies for image/video previews in lf
pacman -S --noconfirm poppler ffmpegthumbnailer
pip3 install ueberzug Pillow

# move dotfiles
/usr/bin/cp $DIR/{.Xresources,.xprofile,.xinitrc} $USRHOME
/usr/bin/cp -r $DIR/config/* $USRHOME/.config/

# move some programs and configs to ~/.local
/usr/bin/cp $DIR/local/* $USRHOME/.local/
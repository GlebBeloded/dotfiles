#!/bin/bash
#script to install all the basic stuff that I need #crash on error set -e
#get path to script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
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

  # AUR installer
  pacman -S --noconfirm trizen

  # Install Desktop environment stuff
  pacman -S --noconfirm i3-wm i3lock unclutter picom rofi pulseaudio xorg-xrandr arandr autorandr bc

  # Install programming stuff
  # C, C++, Python, Go, Rust, node
  pacman -S --noconfirm gcc make cmake python python-pip go rust node npm
  # npm directory access for non root use
  chown -R "$_USER" /usr/local/lib/node_modules
  npm install --global yarn

  # Miscallenious stuff
  pacman -S --noconfirm neovim zsh jq code docker git man
  pacman -S --noconfirm --asdeps xclip xsel

  # install all firefox optional dependencies to get media codecs
  pacman -S --asdeps --noconfirm hunspell-en_US

  # Install media stuff
  pacman -S --noconfirm feh mpv newsboat zathura zathura-pdf-mupdf zathura-djvu translate-shell transmission-cli

  # dependencies for image/video previews in lf
  pacman -S --noconfirm poppler ffmpegthumbnailer w3m imagemagick highlight

  # fonts that I use
  pacman -S --noconfirm terminus-font ttf-font-awesome ttf-cascadia-code ttf-dejavu ttf-liberation noto-fonts-cjk noto-fonts-emoji noto-fonts

  # simple terminal
  git clone https://github.com/GlebBeloded/st.git /tmp/st
  cd /tmp/st
  make install
  cd $DIR

  # make zsh default for user
  usermod --shell /usr/bin/zsh $_USER
  # make zsh default for root
  usermod --shell /usr/bin/zsh $USER
fi

# make sure all neccessary directories exist
if [ $EUID != 0 ]; then
  # Ensure ~/.local exists
  if [ ! -d ~/.local ]; then
    mkdir ~/.local
    if [ ! -d ~/.local/bin ]; then
      mkdir ~/.local/bin
    fi
    if [ ! -d ~/.local/share ]; then
      mkdir ~/.local/share
    fi
  fi

  # Ensure ~/.config exists
  if [ ! -d ~/.config ]; then
    mkdir ~/.config
  fi

fi

# User space installs
if [ $EUID != 0 ]; then
  # Install browser
  trizen -S --noconfirm google-chrome
  # top bar
  trizen -S polybar --noconfirm
  # top replacement
  trizen -S ytop --noconfirm
  # font awesome
  trizen -S ttf-font-awesome-4 --noconfirm
  # lock screen
  trizen -S betterlockscreen --noconfirm

  # install swallow script for i3
  git clone https://github.com/jamesofarrell/i3-swallow.git /tmp/swallow
  /usr/bin/cp /tmp/swallow/swallow ~/.local/bin/

  #install vscode extensions
  while read ext; do
    code --install-extension $ext
  done <$DIR/config/Code\ -\ OSS/extensions

  # lf and stuff which has to do with image previews
  # install lf
  git clone https://github.com/Provessor/lf.git /tmp/lf
  cd /tmp/lf
  go build -o ~/.local/bin/lf
  cd $DIR
  pip3 install ueberzug Pillow i3ipc
fi

# move actual dotfiles
if [ $EUID != 0 ]; then
  # xorg stuff
  /usr/bin/cp $DIR/{.Xresources,.xprofile,.xinitrc} ~
  # dotfiles
  /usr/bin/cp -r $DIR/config/* ~/.config/

  # move some programs and configs to ~/.local
  /usr/bin/cp -r $DIR/local/bin/* ~/.local/bin/
  /usr/bin/cp -r $DIR/local/share/* ~/.local/share/
fi

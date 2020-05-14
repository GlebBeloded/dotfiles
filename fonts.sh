#!/bin/bash
#fonts for polybar
# Powerline fonts / Fontawesome
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

dnf install -y powerline-fonts fontawesome-fonts
# FiraCode font
dnf copr enable -y evana/fira-code-fonts
dnf install -y fira-code-fonts google-noto-cjk-fonts material-design-dark material-design-light
#more fonts bullshit
git clone https://github.com/stark/siji && cd siji
./install.sh
#copy all fonts to destination folder
cp -r $DIR/assets/fonts/.  /usr/share/fonts

dnf install levien-inconsolata-fonts -y
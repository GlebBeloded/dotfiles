#!/bin/bash
#script to install all the basic stuff that I need

dnf update -y && dnf upgrade -y

dnf install -y gcc make cmake g++ go vim zsh

rpm --import https://packages.microsoft.com/keys/microsoft.asc

#vscode repo
if [ ! -f "/etc/yum.repos.d/vscode.repo" ]; then
cat <<EOF | tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
fi

dnf check-update

dnf install -y code

#firefox drivers
dnf install -y gstreamer1 
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y install ffmpeg ffmpeg-devel

#install i3
./i3_install.sh

#move dotfiles
cp .zshrc ~
cp -r i3 ~/.config

usermod --shell /usr/bin/zsh $USER

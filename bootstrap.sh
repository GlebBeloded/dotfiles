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

#install all my stuff
dnf update -y && dnf upgrade -y
dnf install -y gcc make cmake g++ go vim zsh

#install vscode
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
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf -y install ffmpeg ffmpeg-devel

#install i3
if ! [ -x "$(command -v i3)" ]; then
    $DIR/i3_install.sh
fi

#move dotfiles
cp $DIR/.zshrc $USRHOME
cp -r $DIR/i3 $USRHOME

#make zshell default
usermod --shell /usr/bin/zsh $_USER

#torrent client
dnf install transmission-daemon
#stop it in order to substitute config files
systemctl stop transmission-daemon
systemctl disable transmission-daemon.service 

#change folder to which transmission downloads files
sed -i -E "s/(.*\"download-dir\": \"\/home\/)(.*)(\/Downloads\",$)/\1$_USER\3/" $DIR/transmission/settings.json
cp $DIR/transmission/settings.json /var/lib/transmission/.config/transmission-daemon/
#give service user permissions so it can write to ~/Downloads
if ! [ -d "$USRHOME/Downloads" ]; then 
    mkdir "$USRHOME/Downloads"
fi

sed -i "s/User=.*$/User=$_USER/" $DIR/transmission/transmission-daemon.service
cp $DIR/transmission/transmission-daemon.service /usr/lib/systemd/system/transmission-daemon.service
#restart the daemon
systemctl enable transmission-daemon.service 
systemctl start transmission-daemon

#H.264 codec for playing videos 
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install gstreamer1-libav -y

#Nvidia drivers
if [ "$(lspci -vnn | grep VGA | awk '{print $9,$10,$11,$12}')" == '[GeForce GTX 980 Ti]' ]; then
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf install akmod-nvidia -y
fi

exit 0
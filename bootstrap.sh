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
dnf install -y gcc make cmake g++ go vim-X11 zsh zathura zathura-plugins-all jq picom feh polybar webshark
#polybar dependencies
dnf install -y xcb-util-xrm-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-cursor-devel \
xcb-util-image-devel alsa-lib-devel pulseaudio-libs-devel i3-ipc i3-devel jsoncpp-devel \
libmpdclient-devel libcurl-devel wireless-tools-devel libnl3-devel cairo-devel i3

#rust tui system monitor, very pretty
dnf copr enable atim/ytop -y
dnf install ytop -y

#install fonts
$DIR/fonts.sh
fc-cache -f -v

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

#install vscode extensions
while read ext; do
  code --install-extnesion $ext
done < $DIR/config/Code/extensions

dnf check-update
dnf install -y code

#install rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh


#firefox drivers
dnf install -y gstreamer1 
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf -y install ffmpeg ffmpeg-devel

# my dmenu replacement
dnf install -y rofi
# compton from source (tryone version with better blur)
$DIR/compton.sh


#move dotfiles
cp $DIR/.Xresources $USRHOME
cp -r $DIR/config/* $USRHOME/.config/

#make zshell default
usermod --shell /usr/bin/zsh $_USER

#torrent client
dnf install  -y transmission-daemon
#stop it in order to substitute config files
systemctl stop transmission-daemon
systemctl disable transmission-daemon.service 

#change folder to which transmission downloads files
sed -i -E "s/(.*\"download-dir\": \"\/home\/)(.*)(\/Downloads\",$)/\1$_USER\3/" $DIR/transmission/settings.json
#create directory if it does not exist
if ! [ -d "/var/lib/transmission/.config/transmission-daemon" ]; then
    mkdir -p /var/lib/transmission/.config/transmission-daemon
fi
cp  $DIR/transmission/settings.json /var/lib/transmission/.config/transmission-daemon/
#give service user permissions so it can write to ~/Downloads
if ! [ -d "$USRHOME/Downloads" ]; then 
    mkdir "$USRHOME/Downloads"
fi
sed -i "s/User=.*$/User=$_USER/" $DIR/transmission/transmission-daemon.service
if ! [ -d "/usr/lib/systemd/system" ]; then
    mkdir -p /usr/lib/systemd/system
fi
cp  $DIR/transmission/transmission-daemon.service /usr/lib/systemd/system/
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

# messangers
sudo curl -o /etc/yum.repos.d/skype-stable.repo https://repo.skype.com/rpm/stable/skype-stable.repo
sudo dnf install -y skypeforlinux telegram-desktop

#docker stuff
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf makecache
dnf install docker-ce -y
systemctl enable docker.service
systemctl start docker.service

# simple terminal
git clone https://github.com/GlebBeloded/st.git /tmp/st
cd /tmp/st
make install
cd $DIR

# zsh related stuff
# move zshrc 
cp $DIR/.zshrc $USRHOME
cp $DIR/.zshrc /root/
# make zsh default
# zsh history file
mkdir -p $USERHOME/cache/zsh
touch $USERHOME/cache/zsh/history
# zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /tmp/zsh-syntax
cd /tmp/zsh-syntax && make install
cd $DIR


# messy docker install on fedora docker
dnf -y install dnf-plugins-core
dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io -y
grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
systemctl enable docker
#give docker root rights
groupadd docker
usermod -aG docker $_USER

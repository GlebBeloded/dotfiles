#!/bin/bash
# this script is used to install from AUR

git clone $1 $2
cd $2
makepkg -si --noconfirm
cd $DIR
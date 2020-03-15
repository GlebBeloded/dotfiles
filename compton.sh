#!/bin/bash

#install dependencies
dnf -y install libXcomposite-devel libXdamage-devel libXrandr-devel libXinerama-devel libconfig-devel mesa-libGL-devel dbus-devel asciidoc

# Clone the repo
git clone https://github.com/tryone144/compton
# cd into the cloned repo
cd compton
# Make the main program
make
# Make docs
make docs
# Install
make install
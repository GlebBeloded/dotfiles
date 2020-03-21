#!/bin/bash

dnf install gtk3 gtk3-devel vte vte-devel -y
git clone --recursive https://github.com/thestinger/termite.git
bash -c "echo -n PKG_CONFIG_PATH=/usr/local/lib/pkgconfig >> /etc/environment"
cd termite && make
#!/usr/bin/sh
# fetch script is used to grab everything from the environment and put it in git folder to commit

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# xserver config
/bin/cp ~/{.xinitrc,.xprofile,.Xresources} $DIR

# i3 config
/bin/cp ~/.config/i3/config $DIR/config/i3/

# wallpaper that I use
/bin/cp ~/.config/wallpaper $DIR/config/

# picom config
/bin/cp ~/.config/picom.conf $DIR/config/

# polybar config
/bin/cp -r ~/.config/polybar/ $DIR/config/

# vscode stuff
/bin/cp -r ~/.config/Code\ -\ OSS/User/keybindings.json $DIR/config/Code\ -\ OSS/User/keybindings.json
/bin/cp -r ~/.config/Code\ -\ OSS/User/settings.json $DIR/config/Code\ -\ OSS/User/settings.json
code --list-extensions > $DIR/config/Code\ -\ OSS/extensions

# rss reader
/bin/cp -r ~/.newsboat/{urls,config} $DIR/config/newsboat

# zsh stuff
/bin/cp -r ~/{.zprofile,.zshrc} $DIR
/bin/cp -r ~/.config/zsh/aliasrc $DIR/config/zsh/
# update zsh auto-completion scripts
git clone https://github.com/zsh-users/zsh-completions.git /tmp/zsh-completions
cp -r /tmp/zsh-completions/src/{_cmake,_cppcheck,_golang,_openssl,_xinput} $DIR/config/zsh/completions
# rust completions
rustup update
rustup completions zsh > $DIR/config/zsh/completions/_rust

# lf config and scripts
cp -r ~/.config/lf $DIR/config/

# xdg mime-open
cp  ~/.config/mimeapps.list $DIR/config/
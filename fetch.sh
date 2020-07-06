#!/usr/bin/sh
# fetch script is used to grab everything from the environment and put it in git folder to commit

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

/bin/cp /home/gleb/.config/i3/config $DIR/config/i3/
/bin/cp /home/gleb/.Xresources $DIR
/bin/cp /home/gleb/.config/wallpaper $DIR/config/
/bin/cp /home/gleb/.config/compton.conf $DIR/config/
/bin/cp -r /home/gleb/.config/polybar/ $DIR/config/
/bin/cp /home/gleb/.zshrc $DIR
/bin/cp -r /home/gleb/.config/mopidy $DIR/config/
/bin/cp -r /home/gleb/.config/Code/User/keybindings.json $DIR/config/Code/keybindings.json
/bin/cp -r /home/gleb/.config/Code/User/settings.json $DIR/config/Code/settings.json
/bin/cp -r /home/gleb/.newsboat/{urls,config} $DIR/config/newsboat
code --list-extensions > $DIR/config/Code/extensions

# update zsh auto-completion scripts
git clone https://github.com/zsh-users/zsh-completions.git /tmp/zsh-completions
cp -r /tmp/zsh-completions/src/{_cmake,_cppcheck,_golang,_openssl,_xinput} $DIR/config/zsh/completions
# rust completions
rustup update
rustup completions zsh > $DIR/config/zsh/completions/_rust

# vifm config
cp -r /home/gleb/.config/lf/ $DIR/config/lf


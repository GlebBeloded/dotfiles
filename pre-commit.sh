#!/usr/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

/bin/cp /home/gleb/.config/i3/config $DIR/config/i3/
/bin/cp /home/gleb/.Xresources $DIR
/bin/cp /home/gleb/.config/wallpaper $DIR/config/
/bin/cp /home/gleb/.config/compton.conf $DIR/config/
/bin/cp -r /home/gleb/.config/polybar/ $DIR/config/
/bin/cp -r /home/gleb/.config/termite $DIR/config/
/bin/cp /home/gleb/.zshrc $DIR
/bin/cp -r /home/gleb/.config/mopidy $DIR/config/

# Enable colors and change prompt:
autoload -U colors && colors

# terminal prompt
PROMPT="%(?..%F{red}✘ )%B%F{yellow}[%F{magenta}%~%F{yellow}] %(!.%F{red}%B▶ .%F{green}%B▶ "

# right prompt with git info
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats "%F{yellow} %b"
zstyle ':vcs_info:*' enable git
RPROMPT=\$vcs_info_msg_0_

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
fpath=(~/.config/zsh/completions $fpath)
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Enable vim yank-paste in normal mode
vi-append-x-selection () { RBUFFER=$(xsel -o -p </dev/null)$RBUFFER; }
zle -N vi-append-x-selection
bindkey -a '^p' vi-append-x-selection
vi-yank-x-selection () { print -rn -- $CUTBUFFER | xsel -i -p; }
zle -N vi-yank-x-selection
bindkey -a '^y' vi-yank-x-selection

#enable copy and paste to system clipboard by aliasing gvim as vim
alias vim='nvim'

#add golang to path
export GOPATH=$HOME/go
PATH=$PATH:~/go/bin 
PATH=$PATH:~/.local/bin
PATH=$PATH:/usr/local/go/bin
export PATH
export GOBIN=$GOPATH/bin
export GO111MODULE=on

#add rust to path
export PATH="$HOME/.cargo/bin:$PATH"

# Woohoo, weather!
alias weather="curl wttr.in"
# Woohoo, pointless map!
alias map="telnet mapscii.me"

# Load zsh-syntax-highlighting; should be last.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

bindkey -e
autoload -U colors && colors
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

export HISTFILE="$ZDOTDIR/.histfile"
HISTSIZE=10000
SAVEHIST=10000

if [ -z "$WAYLAND_DISPLAY" ] && [ "XDG_VTNR" = 1 ]; then
  exec dbus-run-session river
fi

zmodload zsh/complist
autoload -U compinit
autoload -U colors && colors
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
_comp_options+=(globdots)
compinit

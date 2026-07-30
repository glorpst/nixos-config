{ ... }: {
  flake.nixosModules.zsh = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      interactiveShellInit = ''
        bindkey -e
        autoload -U colors && colors
        PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "

        # update terminal 'title'
        autoload -Uz add-zsh-hook
        function set_title_precmd() { print -Pn "\e]0;%~\a" }
        function set_title_preexec() { print -Pn "\e]0;$1\a" }
        add-zsh-hook precmd set_title_precmd
        add-zsh-hook preexec set_title_preexec

        export HISTFILE="$ZDOTDIR/.histfile"
        HISTSIZE=10000
        SAVEHIST=10000

        zmodload zsh/complist
        autoload -U compinit
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        _comp_options+=(globdots)
        compinit
      '';
    };
  };
}

{ inputs, ... }: {
  perSystem = { pkgs, lib, self', ... }: {
    packages = {
      tmux-sessionizer = pkgs.writeShellApplication {
        name = "tmux-sessionizer";
        runtimeInputs = [ pkgs.tmux pkgs.fzf pkgs.coreutils pkgs.findutils ];
        text = ''
          if [[ $# -eq 1 ]]; then
              selected=$1
          else
              selected=$(find ~/Projects ~/Documents -mindepth 1 -maxdepth 1 -type d | fzf)
          fi
          if [[ -z $selected ]]; then exit 0; fi
          selected_name=$(basename "$selected" | tr . _)
          tmux_running=$(pgrep tmux)
          if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
              tmux new-session -s "$selected_name" -c "$selected"
              exit 0
          fi
          if ! tmux has-session -t="$selected_name" 2> /dev/null; then
              tmux new-session -ds "$selected_name" -c "$selected"
          fi
          if [[ -z $TMUX ]]; then
              tmux attach-session -t "$selected_name"
          else
              tmux switch-client -t "$selected_name"
          fi
        '';
      };

      myTmux = inputs.wrapper-modules.wrappers.tmux.wrap {
        inherit pkgs;
        settings = ''
          # Your default configs can go here eventually
          
          # Bind the sessionizer to a key (e.g., prefix + f)
          bind-key -r f run-shell "tmux neww ${lib.getExe self'.packages.tmux-sessionizer}"
        '';
      };
    };
  };
}

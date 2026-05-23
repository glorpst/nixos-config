{ config, pkgs, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    nvim = "nvim";
    alacritty = "alacritty";
    kitty = "kitty";
    quickshell = "quickshell";
    waybar = "waybar";
    zsh = "zsh";

    gtk_theme = "gtk_theme";
    icon_theme = "icon_theme";
  };
in

{
  home.stateVersion = "24.05"; # no touch

  programs = {
    home-manager.enable = true;
    nvf.enable = true;
  }; 

  services = {
    mako.enable = true;
  };

  imports = [
    ./../../home-manager-modules
    inputs.nvf.homeManagerModules.default
  ];

  home.file = {
    ".local/share/themes/ClassicPlatinumStreamlined".source = ../../config/gtk_theme/ClassicPlatinumStreamlined;
    ".local/share/themes/RetroismIcons".source = ../../config/icon_theme/RetroismIcons;
  };

  gtk = {
    enable = true;
    theme = {
      name = "ClassicPlatinumStreamlined";
      package = null;
    };
    iconTheme = {
      name = "RetroismIcons";
      package = null;
    };
  };

  home.packages = with pkgs; [
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    gnumake
    gdb
    rustc
    cargo
    
    wlr-randr

    hyprland
    hyprpaper
    hyprshot
    quickshell
    nemo
    nwg-look
    wl-clipboard
    mako
    grim
    slurp
    swappy
    dconf
    jq
    socat

    neovim
    tmux
    firefox
    alacritty
    kitty
    
  ];

  home.sessionVariables = {
    ZDOTDIR = "$HOME/.config/zsh";
    NIXOS_OZONE_WL = "1";
  };

  home.file.".zshenv".text = ''export ZDOTDIR="$HOME/.config/zsh"'';

  xdg.configFile = builtins.mapAttrs 
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}

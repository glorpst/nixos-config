{ inputs, ... }: {

  flake.homeManagerModules.laptopHome = { config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    alacritty = "alacritty";
    hypr = "hypr";
    # niri = "niri";
    nvim = "nvim";
    kitty = "kitty";
    # quickshell = "quickshell";
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
    ./../../../home-manager
    inputs.nvf.homeManagerModules.default
  ];

  home.file = {
    ".local/share/themes/ClassicPlatinumStreamlined".source = ../../../config/gtk_theme/ClassicPlatinumStreamlined;
    ".local/share/icons/RetroismIcons".source = ../../../config/icon_theme/RetroismIcons;

  };

  gtk = {
    enable = true;

    gtk4.theme = null;

    theme = {
      name = "ClassicPlatinumStreamlined";
      package = null;
    };

    iconTheme = {
      name = "RetroismIcons";
      package = null;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "glorpst";
        email = "128099126+glorpst@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      # pull.rebase = true;
      url."git@github.com:".insteadOf = "https://github.com/";
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
    niri
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
    qt5.qtwayland
    qt6.qtwayland
    udiskie
    swaybg

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
};
}

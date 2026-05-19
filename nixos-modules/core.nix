{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.graphics.enable = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    unzip
    killall
    man-pages
    man-pages-posix
  ];

  fonts.packages = with pkgs; [
   nerd-fonts.commit-mono
   nerd-fonts.jetbrains-mono
   nerd-fonts.fira-code

   noto-fonts
   noto-fonts-cjk-sans
   noto-fonts-color-emoji
   liberation_ttf
  ];

  services.xserver.xkb.layout = "us";
  time.timeZone = "America/Chicago";
  
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}

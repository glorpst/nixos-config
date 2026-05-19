{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../nixos-modules
    inputs.home-manager.nixosModules.default
    inputs.nvf.nixosModules.default
  ];

  networking.hostName = "nixos"; # hostname

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # bootloader #TODO systemd-boot, other more epic boots
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.wireless.enable = true;
  # Enables wireless support via wpa_supplicant
  networking.networkmanager.enable = true;

  nix.settings.download-buffer-size = 536870912;

  users.users.glorpst = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [

    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users."glorpst" = import ./home.nix;
  };

  modules = {
    desktop.enable = true;
  };
  
  programs.nh = {
    enable = true;
    flake = "/home/glorpst/nixos";

    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 10";
    };
  };
  environment.variables = {
    FLAKE = "/home/glorpst/nixos";
  };

  environment.systemPackages = with pkgs; [
    nh
    git
    vim
    wget
    unzip
    killall
    libnotify
  ];

  system.stateVersion = "25.05";
}

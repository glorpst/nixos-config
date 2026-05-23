{ config, pkgs, lib, inputs, sysUser, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../nixos-modules
    inputs.home-manager.nixosModules.default
    inputs.nvf.nixosModules.default
  ];

  networking.hostName = "ooo"; # hostname, must match vars in flake.nix to build with nh

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

  users.users.${sysUser} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    # packages = with pkgs; [
    # ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs sysUser; };
    users.${sysUser} = import ./home.nix;
  };

  modules = {
    desktop.enable = true;
  };
  
  programs.nh = {
    enable = true;
    flake = "/home/${sysUser}/nixos";

    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 10";
    };
  };
  environment.variables = {
    FLAKE = "/home/${sysUser}/nixos";
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

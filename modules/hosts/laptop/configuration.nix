{ self, config, pkgs, lib, inputs, sysUser, ... }: {

  flake.nixosModules.laptopConfiguration = { pkgs, lib, ... }: {
    imports = [
      ./hardware-configuration.nix
      ./../../nixos
      inputs.home-manager.nixosModules.default
      inputs.nvf.nixosModules.default
    ];

    networking.hostName = "ooo"; # hostname, must match vars in flake.nix to build with nh

    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.useOSProber = true;

    # bootloader #TODO systemd-boot, other more epic boots
    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.wireless.enable = false;
    # Enables wireless support via wpa_supplicant
    networking.networkmanager.enable = true;
    networking.wireless.iwd.enable = false;

    hardware.enableAllFirmware = true;

    # USB detection
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    nix.settings.download-buffer-size = 536870912;

    users.users.peebs = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      # packages = with pkgs; [
      # ];
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs sysUser; };
      users.peebs = import ./home.nix;
    };

    modules = {
      desktop.enable = true;
    };
  
    programs.nh = {
      enable = true;
      flake = "/home/peebs/nixos";

      clean = {
        enable = true;
        extraArgs = "--keep-since 30d --keep 10";
      };
    };
    environment.variables = {
      FLAKE = "/home/peebs/nixos";
    };

    environment.systemPackages = with pkgs; [
      nh
      git
      vim
      wget
      unzip
      killall
      libnotify
      networkmanagerapplet
    ];

    system.stateVersion = "25.05";
  };
}

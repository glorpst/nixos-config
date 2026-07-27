{ self, inputs, ... }: {

  flake.nixosModules.laptopConfiguration = { pkgs, lib, ... }: {
    imports = [
      ./../../../nixos
      self.nixosModules.laptopHardware
      self.nixosModules.laptopDisko
      self.nixosModules.cli
      self.nixosModules.desktop
      self.nixosModules.gaming
      inputs.home-manager.nixosModules.default
      inputs.disko.nixosModules.default
      inputs.nvf.nixosModules.default
    ];

    security.pam.services.noctalia = {};

    networking.hostName = "bmo"; # hostname, must match vars in flake.nix to build with nh

    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.useOSProber = true;

    # TODO: systemd-boot, other more epic boots
    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    # networking.wireless.enable = false;
    # Enables wireless support via wpa_supplicant
    # supposedly for pia vpn
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
    networking.networkmanager = { 
      enable = true; 
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
    # networking.wireless.iwd.enable = false;

    hardware.enableAllFirmware = true;

    # USB detection
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    nix.settings.download-buffer-size = 536870912;

    # noctalia dependencies
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    

    systemd.services.delay-suspend = {
      description = "delays 'suspend' to prevent screen lock race condition issues";
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/sleep 1";
      };
    };

    users.users.glorpst = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      # packages = with pkgs; [
      # ];
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users.glorpst = self.homeManagerModules.laptopHome;
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

    fonts.fontconfig = {
      defaultFonts = {
        sansSerif = [ "Inter" "Noto Color Emoji" "Symbols Nerd Font" ];
        serif = [ "Noto Serif" "Noto Color Emoji" "Symbols Nerd Font" ];
        monospace = [ "Iosevka NF Medium" "Noto Color Emoji" "Symbols Nerd Font" ];
      };
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

      spotify-player
    ];

    system.stateVersion = "25.05";
  };
}

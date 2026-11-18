{ self, inputs, ... }: {

  flake.nixosModules.laptopConfiguration = { pkgs, lib, ... }: {
    imports = [
      ./../../../nixos
      self.nixosModules.laptopHardware
      self.nixosModules.laptopDisko
      self.nixosModules.cli
      self.nixosModules.niri
      self.nixosModules.gaming
      inputs.home-manager.nixosModules.default
      inputs.disko.nixosModules.default
    ];

    security.pam.services.noctalia = { };

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

    # battery charge control without TLP, as it conflicts with power-profiles-daemon, a dependency for Noctalia shell
    environment.shellAliases = {
      bat-low = "echo 60 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold && echo 55 | sudo tee /sys/class/power_supply/BAT0/charge_control_start_threshold";
      bat-med = "echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold && echo 75 | sudo tee /sys/class/power_supply/BAT0/charge_control_start_threshold";
      bat-high = "echo 100 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold && echo 0 | sudo tee /sys/class/power_supply/BAT0/charge_control_start_threshold";
      bat-stat = "echo 'Start:' \$(cat /sys/class/power_supply/BAT0/charge_control_start_threshold)% 'End:' \$(cat /sys/class/power_supply/BAT0/charge_control_end_threshold)%";
    };
    
    # noctalia dependencies
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    services.tailscale.enable = true;
    services.openssh.enable = true;

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
      extraGroups = [
        "networkmanager"
        "wheel"
        "wireshark"
      ];
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

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    fonts.fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Inter"
          "Noto Color Emoji"
          "Symbols Nerd Font"
        ];
        serif = [
          "Noto Serif"
          "Noto Color Emoji"
          "Symbols Nerd Font"
        ];
        monospace = [
          "Iosevka NF Medium"
          "Noto Color Emoji"
          "Symbols Nerd Font"
        ];
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

      anki
      libreoffice
      spotify-player
      mpv
      wayvnc
    ];

    system.stateVersion = "25.05";
  };
}

{ ... }: {
  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          ControllerMode = "dual";
          Experimental = true;
        };
      };
    };

    boot.extraModprobeConfig = ''
      options bluetooth disable_ertm=1
    '';

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}

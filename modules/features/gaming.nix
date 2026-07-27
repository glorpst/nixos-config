{ ... }: {
  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = true;
      enable32bit = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}

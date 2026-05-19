{ lib, config, ... }:

{
  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop";
  };

  config = lib.mkIf config.modules.desktop.enable {
    programs.hyprland.enable = true;
    programs.river-classic.enable = true;
    programs.xwayland.enable = true;

    services.displayManager.ly = {
      enable = true;
    };
  };
}

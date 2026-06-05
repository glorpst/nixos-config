{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = let
        noctaliaExe = lib.getExe self'.packages.myNoctalia;
        in {

          input = {
            focus-follows-mouse = _: {};

            keyboard = {
              xkb = {
                layout = "us";
                options = "caps:escape";
              };
              repeat-delay = 300;
              repeat-rate = 30;
            };

            touchpad = {
              dwt = _: {};
              dwtp = _: {};
              click-method = "button-areas";
            };

            mouse = {
              accel-profile = "flat";
            };
          };

          outputs = {
            "eDP-1" = {
              scale = 1.0;
              background-color = "#000000";
              position = _: { props = { x = 0; y = 0; }; };
            };

            "HDMI-A-1" = {
              mode = "1920x1080@119.982";
              transform = "90";
              position = _: { props = { x = 1920; y = 0; }; };
            };
          };

          window-rules = [
          # {
          #   matches = [{}];
          #
          #   geometry-corner-radius = 12.0;
          #   clip-to-geometry = true;
          # }

          {
            matches = [{ app-id = "kitty"; }];

            background-effect = {
              blur = true;
            };
            open-maximized = true;
            default-column-width = { proportion = 1.0; };
          }];

          # Keybinds
          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;

            "Mod+Q".close-window = _: {};
            "Mod+M".maximize-column = _: {};
            "Mod+F".fullscreen-window = _: {};
            "Mod+Shift+F".toggle-window-floating = _: {};
            # "Mod+C".center-column = _: {};

            "Mod+H".focus-column-left = _: {};
            "Mod+L".focus-column-right = _: {};
            "Mod+K".focus-window-up = _: {};
            "Mod+J".focus-window-down = _: {};

            "Mod+Left".focus-column-left = _: {};
            "Mod+Right".focus-column-right = _: {};
            "Mod+Up".focus-window-up = _: {};
            "Mod+Down".focus-window-down = _: {};

            "Mod+Shift+H".move-column-left = _: {};
            "Mod+Shift+L".move-column-right = _: {};
            "Mod+Shift+K".move-window-up = _: {};
            "Mod+Shift+J".move-window-down = _: {};

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;
            "Mod+0".focus-workspace = 10;

            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Shift+6".move-column-to-workspace = 6;
            "Mod+Shift+7".move-column-to-workspace = 7;
            "Mod+Shift+8".move-column-to-workspace = 8;
            "Mod+Shift+9".move-column-to-workspace = 9;
            "Mod+Shift+0".move-column-to-workspace = 10;

            "Mod+WheelScrollDown".focus-column-left = _: {};
            "Mod+WheelScrollUp".focus-column-right = _: {};
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: {};
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: {};

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            "Mod+Comma".focus-monitor-left = _: {};
            "Mod+Period".focus-monitor-right = _: {};
            "Mod+Shift+Comma".move-window-to-monitor-left = _: {};
            "Mod+Shift+Period".move-window-to-monitor-right = _: {};
            
            "Mod+D".spawn-sh = "${noctaliaExe} ipc call launcher toggle";

            "Mod+V".spawn-sh = ''${pkgs.alsa-utils}/bin/amixer sset Capture toggle'';
            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioMicMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            "XF86MonBrightnessUp".spawn-sh = "brightnessctl s 10%+";
            "XF86MonBrightnessDown".spawn-sh = "brightnessctl s 10%-";

            "Mod+Ctrl+S".spawn-sh = ''${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy'';
            "Mod+Ctrl+E".spawn-sh = ''${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -'';
            "Mod+Shift+S".spawn-sh = lib.getExe (pkgs.writeShellApplication {
              name = "screenshot";
              text = ''
                ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
                | ${pkgs.wl-clipboard}/bin/wl-copy
              '';
            });
          
          };

          layout = {
            gaps = 5;
            focus-ring = {
              width = 2;
              active-color = "#88c0d0";
            };
          };
          
          environment = {
            XDG_CURRENT_DESKTOP = "niri";
            XDG_SESSION_DESKTOP = "niri";
            XDG_SESSION_TYPE = "wayland";
            QT_QPA_PLATFORM = "wayland;xcb";
            QT_QPA_PLATFORMTHEME = "gtk3";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          };

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          
          spawn-at-startup = [
            (lib.getExe (pkgs.writeShellScriptBin "dbus-update" ''
              dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            ''))

            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"

            (lib.getExe self'.packages.myNoctalia)
            # (lib.getExe (pkgs.writeShellScriptBin "wallpapers" ''
            #   ${lib.getExe pkgs.swaybg} -o eDP-1 -i ~/Pictures/opt_wallpapers/metropolis.png &
            #   ${lib.getExe pkgs.swaybg} -o HDMI-A-1 -i ~/Pictures/opt_wallpapers/tall_building.jpg &
            # ''))
          ];
        };
      };
    };
}

{
  lib,
  pkgs,
  config,
  systemConfig,
  ...
}:

let
  cfg = config.jopejoe1.niri;
in
{
  options.jopejoe1.niri = {
    enable = lib.mkEnableOption "setting up niri";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;
    programs.fuzzel.enable = true;
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
    programs.swaylock.enable = true;
    programs.niri.settings = {
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite-unstable;
      };
      prefer-no-csd = true;
      window-rules = [
        {
          open-floating = false;
          open-focused = false;
        }
      ];
      outputs = {
        "Acer Technologies Acer AL1717 0x70201097" = {
          mode = {
            height = 1024;
            width = 1280;
            refresh = 75.025;
          };
          position = {
            x = 2560;
            y = 0;
          };
        };
        "LG Electronics LG ULTRAGEAR+ 305NTLE00976" = {
          mode = {
            height = 1440;
            width = 2560;
            refresh = 143.991;
          };
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = true;
          focus-at-startup = true;
        };
        "Eizo Nanao Corporation EV2316W 36270122" = {
          mode = {
            height = 1080;
            width = 1920;
            refresh = 60.00;
          };
          position = {
            x = -1080;
            y = 0;
          };
          transform.rotation = 90;
        };
      };
      binds = with config.lib.niri.actions; {
        "Super+D".action.spawn = "fuzzel";
        "Super+Shift+E".action = quit;
        "Super+Q".action = close-window;
        "Super+T".action.spawn = "alacritty";
        "Alt+L".action.spawn = "swaylock";
        "Super+Equal".action = set-column-width "+10%";
        "Super+Minus".action = set-column-width "-10%";
        "Super+F".action = maximize-column;
        "Super+H".action = focus-column-left;
        "Super+L".action = focus-column-right;
        "Super+K".action = focus-window-up;
        "Super+J".action = focus-window-down;
        "Super+I".action = focus-workspace-up;
        "Super+U".action = focus-workspace-down;
        "Super+Shift+H".action = focus-monitor-left;
        "Super+Shift+L".action = focus-monitor-right;
        "Super+Shift+K".action = focus-monitor-up;
        "Super+Shift+J".action = focus-monitor-down;
        "Super+Shift+I".action = move-workspace-up;
        "Super+Shift+U".action = move-workspace-down;
        "Super+Alt+H".action = move-column-left;
        "Super+Alt+L".action = move-column-right;
        "Super+Alt+K".action = move-window-up;
        "Super+Alt+J".action = move-window-down;
        "Super+Alt+I".action = move-column-to-workspace-up;
        "Super+Alt+U".action = move-column-to-workspace-down;
        "Super+Alt+Shift+H".action = move-column-to-monitor-left;
        "Super+Alt+Shift+L".action = move-column-to-monitor-right;
        "Super+Alt+Shift+K".action = move-column-to-monitor-up;
        "Super+Alt+Shift+J".action = move-column-to-monitor-down;
      };
      input.keyboard.xkb = {
        inherit (systemConfig.services.xserver.xkb)
          variant
          options
          model
          layout
          ;
      };
    };
  };
}

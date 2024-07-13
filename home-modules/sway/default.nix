{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.sway;
in
{
  options.jopejoe1.sway = {
    enable = lib.mkEnableOption "Enable Sway";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        output = {
          HDMI-A-4 = {
            mode = "1280x1024@75.025Hz";
            pos = "2560 0";
          };
          HDMI-A-3 = {
            mode = "2560x1440@143.991Hz";
            adaptive_sync = "on";
            pos = "0 0";
          };
          DP-3 = {
            mode = "1920x1080@60.000Hz";
            transform = "270";
            pos = "-1080 0";
          };
        };
      };
    };
  };
}

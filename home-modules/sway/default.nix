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
          "Acer Technologies Acer AL1717 0x70201097" = {
            mode = "1280x1024@75.025Hz";
            pos = "2560 0";
          };
          "LG Electronics LG ULTRAGEAR+ 305NTLE00976" = {
            mode = "2560x1440@143.991Hz";
            adaptive_sync = "on";
            pos = "0 0";
          };
          "Eizo Nanao Corporation EV2316W 36270122" = {
            mode = "1920x1080@60.000Hz";
            transform = "270";
            pos = "-1080 0";
          };
        };
      };
    };
  };
}

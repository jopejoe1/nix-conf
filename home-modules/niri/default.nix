{
  lib,
  pkgs,
  config,
  nixosConfig,
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
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = lib.getExe pkgs.alacritty;
          layer = "overlay";
        };
      };
    };
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
    programs.swaylock.enable = true;
  };
}

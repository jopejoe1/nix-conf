{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.system.xdg;
in
{
  options.custom.system.xdg = with types; {
    enable = mkBoolOpt false "Whether or not to enable xdg.";
  };

  config = mkIf cfg.enable {
    xdg = {
      sounds.enable = true;
      mime.enable = true;
      menus.enable = true;
      icons.enable = true;
      autostart.enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal ];
      };
    };
  };
}

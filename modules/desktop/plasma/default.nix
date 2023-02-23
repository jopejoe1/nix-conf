{ options, config, lib, pkgs, ... }:

with lib;
#with lib.internal;
let
  cfg = config.custom.desktop.plasma;
in
{
  options.custom.desktop.plasma = with types; {
    enable = mkBoolOpt false "Whether or not to use KDE plasma as the desktop environment.";
  };

  config = mkIf cfg.enable {

    services.xserver = {
      enable = true;

      libinput.enable = true;

      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
      };
      desktopManager.plasma5 = {
        enable = true;
        useQtScaling = true;
        supportDDC = true;
      };
    };

    programs.kdeconnect = {
      enable = true;
      package = pkgs.plasma5Packages.kdeconnect-kde;
    };
  };
}

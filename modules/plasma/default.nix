{ config, lib, pkgs, ... }:

let
  cfg = config.jopejoe1.plasma;
in
{
  options.jopejoe1.plasma = {
    enable = lib.mkEnableOption "Enable KDE Plasma";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;

        libinput.enable = true;

        displayManager.sddm = {
          enable = true;
          enableHidpi = true;
        };
        desktopManager.plasma5 = {
          enable = true;
          useQtScaling = true;
        };
      };
    };

    programs.kdeconnect = {
      enable = true;
    };
  };
}


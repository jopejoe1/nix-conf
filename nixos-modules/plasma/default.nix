{ config, lib, ... }:

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
      };

      libinput.enable = true;

      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
      };
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };

    programs.kdeconnect = {
      enable = true;
    };

    networking.networkmanager.enable = true;
    services.xserver.enable = true;
  };
}

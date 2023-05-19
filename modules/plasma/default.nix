{ pkgs, ... }:

{
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
    package = pkgs.plasma5Packages.kdeconnect-kde;
  };
}



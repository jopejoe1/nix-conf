{ config, lib, pkgs, self, ... }:

let cfg = config.jopejoe1.kodi;
in {
  options.jopejoe1.kodi = { enable = lib.mkEnableOption "Enable Kodi"; };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kodi ];
    services.xserver = {
      enable = true;
      desktopManager.kodi = {
        enable = false;
        package = pkgs.kodi-wayland;
      };
      displayManager = {
        defaultSession = "";
        autoLogin = {
          enable = true;
          user = "jopejoe1";
        };
        lightdm = {
          enable = true;
          autoLogin.timeout = 3;
        };
        sddm.enable = lib.mkForce false;
      };
    };
  };
}

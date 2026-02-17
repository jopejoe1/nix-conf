{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.kodi;
in
{
  options.jopejoe1.kodi = {
    enable = lib.mkEnableOption "Enable Kodi";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kodi-wayland ];
    services.xserver = {
      enable = true;
      desktopManager.kodi = {
        enable = false;
        package = pkgs.kodi-wayland;
      };
      displayManager = {
        lightdm = {
          enable = true;
          autoLogin.timeout = 3;
        };
      };
    };
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "jopejoe1";
      };
      sddm.enable = lib.mkForce false;
    };
  };
}

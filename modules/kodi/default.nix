{ config, lib, pkgs, self, ... }:

let cfg = config.jopejoe1.kodi;
in {
  options.jopejoe1.kodi = { enable = lib.mkEnableOption "Enable Kodi"; };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.kodi.enable = true;
      displayManager = {
        autoLogin = {
          enable = false;
          user = "jopejoe1";
        };
        lightdm = {
          enable = true;
          autoLogin.timeout = 3;
        };
      };
    };
  };
}


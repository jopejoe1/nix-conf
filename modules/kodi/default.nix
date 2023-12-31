{ config, lib, pkgs, self, ... }:

let cfg = config.jopejoe1.kodi;
in {
  options.jopejoe1.kodi = { enable = lib.mkEnableOption "Enable Kodi"; };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManger.kodi.enable = true;
      displayManager = {
        autoLogin = {
          enable = true;
          user = "jopejoe1";
        };
        ligthdm = {
          enable = true;
          autoLogin.timeout = 3;
        };
      };
    };
  };
}


{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.local;
in
{
  options.jopejoe1.local = {
    enable = lib.mkEnableOption "Enable Locals";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      sounds.enable = config.jopejoe1.gui.enable;
      mime.enable = true;
      menus.enable = config.jopejoe1.gui.enable;
      icons.enable = config.jopejoe1.gui.enable;
      autostart.enable = true;
      portal = {
        enable = config.jopejoe1.gui.enable;
        extraPortals = with pkgs; [ xdg-desktop-portal ];
      };
    };

    i18n = {
      defaultLocale = "en_NZ.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
        LC_CTYPE = "de_DE.UTF-8";
        LC_COLLATE = "de_DE.UTF-8";
        LC_MESSAGES = "en_NZ.UTF-8";
      };
    };

    environment.variables = {
      LOG_ICONS = "true";
    };

    fonts.fontDir.enable = true;
  };
}

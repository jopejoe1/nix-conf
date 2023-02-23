{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.system.locale;
in
{
  options.custom.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to manage locale settings.";
    layout = mkOpt str "de" "The Keyboard layout to use.";
  };

  config = mkIf cfg.enable {
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
    console = {
      enable = true;
      keyMap = mkForce cfg.layout;
    };
    services.xserver = {
      layout = cfg.layout;
    };

  };
}

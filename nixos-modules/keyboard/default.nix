{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.keyboard;
in
{
  options.jopejoe1.keyboard = {
    enable = lib.mkEnableOption "Enable Keyboard";
    layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = lib.mdDoc "Keyboard Layout.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        xkb.layout = cfg.layout;
      };
    };
    console = {
      enable = true;
      keyMap = cfg.layout;
    };
  };
}

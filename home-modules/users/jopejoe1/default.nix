{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.users.jopejoe1;
in
{
  options.jopejoe1.users.jopejoe1 = {
    enable = lib.mkEnableOption "Enable jopejoe1 user";
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
    };
    jopejoe1 = {
      common = {
        enable = true;
      };
      nushell.enable = true;
      git.enable = true;
      direnv.enable = true;
      sway.enable = true;
      firefox.enable = config.jopejoe1.common.gui;
    };
    catppuccin = {
      enable = true;
      flavor = "frappe";
      accent = "mauve";
    };
  };
}

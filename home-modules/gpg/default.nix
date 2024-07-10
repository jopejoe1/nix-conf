{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.gpg;
in
{
  options.jopejoe1.gpg = {
    enable = lib.mkEnableOption "Enable Nushell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };
    };
  };
}

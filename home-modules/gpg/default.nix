{
  config,
  lib,
  ...
}:

let
  cfg = config.jopejoe1.gpg;
in
{
  options.jopejoe1.gpg = {
    enable = lib.mkEnableOption "setup gpg";
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

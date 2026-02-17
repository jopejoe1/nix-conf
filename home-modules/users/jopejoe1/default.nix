{
  config,
  lib,
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
    jopejoe1 = {
      common = {
        enable = true;
      };
      nushell.enable = true;
      git.enable = true;
      direnv.enable = true;
      helix.enable = true;
      jj.enable = true;
      firefox.enable = config.jopejoe1.common.gui;
    };
  };
}

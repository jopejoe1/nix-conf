{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.user.root;
in
{
  options.custom.user.root = with types; {
    enable = mkBoolOpt false "Enable the user root";
  };

  config = mkIf cfg.enable {
    custom.user.root.home.enable = true;
  };
}

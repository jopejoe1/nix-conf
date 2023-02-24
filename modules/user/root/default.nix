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

    home-manager.users.root = import ./home.nix;
  };
}

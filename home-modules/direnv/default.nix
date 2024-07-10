{ config, lib, ... }:

let
  cfg = config.jopejoe1.direnv;
in
{
  options.jopejoe1.direnv = {
    enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

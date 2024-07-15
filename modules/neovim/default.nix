{ config, lib, ... }:

let
  cfg = config.jopejoe1.neovim;
in
{
  options.jopejoe1.neovim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
    };
  };
}

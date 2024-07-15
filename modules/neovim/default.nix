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
      viAlias = true;
      vimAlias = true;
      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "frappe";
      };
      plugins = {
        treesitter.enable = true;
        direnv.enable = true;
      };
    };
  };
}

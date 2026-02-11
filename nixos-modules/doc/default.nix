{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.jopejoe1.doc;
in
{
  options.jopejoe1.doc = {
    enable = lib.mkEnableOption "Enable Documentation";
  };

  config = lib.mkIf cfg.enable {
    documentation = {
      enable = true;
      doc.enable = true;
      dev.enable = true;
      info.enable = true;
      nixos = {
        enable = true;
        includeAllModules = true;
        options.warningsAreErrors = false;
      };
      man = {
        enable = true;
        generateCaches = false;
      };
    };
    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
      linux-manual
    ];
  };
}

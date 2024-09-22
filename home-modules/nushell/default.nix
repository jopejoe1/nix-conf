{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.nushell;
in
{
  options.jopejoe1.nushell = {
    enable = lib.mkEnableOption "Enable Nushell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;
        extraConfig = ''
          $env.config = {
            show_banner: false,
          }
        '';
      };

      carapace.enable = true;
      carapace.enableNushellIntegration = true;
     # carapace.package = pkgs.carapace.overrideAttrs {
     #   src = /home/jopejoe1/dev/carapace-bin/././././.;
     #   vendorHash = "sha256-z2sxm+qxSCU60kJqI6Rg9KQRizqgJlZWjvb0zxwSL2o=";
     # };

      starship = {
        enable = true;
        settings = {
          add_newline = true;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
      };
    };
  };
}

{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.nushell;
in {
  options.jopejoe1.nushell = {
    enable = lib.mkEnableOption "Enable Nushell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;
      };

      carapace.enable = true;
      carapace.enableNushellIntegration = true;

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



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
        extraConfig = ''
          let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
          }
          $env.config = {
           show_banner: false,
           completions: {
           case_sensitive: false
           quick: true
           partial: true
           algorithm: "fuzzy"
           external: {
               enable: true
               max_results: 100
               completer: $carapace_completer
             }
           }
          }
        '';
        shellAliases = {
          vi = "nvim";
          vim = "nvim";
        };
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



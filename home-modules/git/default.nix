{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.git;
in {
  options.jopejoe1.git = {
    enable = lib.mkEnableOption "Enable Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.git;
      userEmail = "johannes@joens.email";
      userName = "jopejoe1";
      extraConfig = {
        core = {
          whitespace = [ "blank-at-eol" "blank-at-eof" "space-before-tab" ];
        };
      };
    };
  };
}



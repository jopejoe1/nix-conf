{ config, lib, ... }:

let cfg = config.jopejoe1.sway;
in {
  options.jopejoe1.sway = {
    enable = lib.mkEnableOption "Enable Sway";
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
    };
  };
}


{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.hardware.rgb;
in
{
  options.custom.hardware.rgb = with types; {
    enable = mkBoolOpt false "Whether or not to enable openrgb";
    motherboard = mkOpt str "intel" "Which motherboard to use"; # Move to common CPU module at some point
  };

  config = mkIf cfg.enable {

    services.hardware.openrgb.enable = true;
    services.hardware.openrgb.motherboard = cfg.motherboard;

  };
}

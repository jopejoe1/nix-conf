{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.hardware.printing;
in
{
  options.custom.hardware.printing = with types; {
    enable = mkBoolOpt false "Whether or not to enable printing and scaning";
    printers = mkOpt (listOf package) [ ] "Custom printing backend packages to install.";
  };

  config = mkIf cfg.enable {

    services.printing = {
      enable = true;
      webInterface = true;
      drivers = with pkgs; [
        hplipWithPlugin
      ] ++ cfg.printers;
    };

    hardware = {
      sane = {
        enable = true;
        extraBackends = with pkgs; [
          sane-airscan
          hplipWithPlugin
        ] ++ cfg.printers;
      };
    };

    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };
}

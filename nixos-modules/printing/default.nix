{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.printing;
in
{
  options.jopejoe1.printing = {
    enable = lib.mkEnableOption "Enable Printing";
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      webInterface = true;
      drivers = with pkgs; [ hplip epson-escpr2 epson-escpr ];
    };

    hardware = {
      sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan pkgs.epsonscan2 ];
      };
    };

    services.avahi = {
      enable = false; # TODO: fix with immutable etc
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
  };
}

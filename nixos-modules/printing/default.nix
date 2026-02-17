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
      drivers = with pkgs; [ hplip ];
    };

    hardware = {
      sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan ];
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

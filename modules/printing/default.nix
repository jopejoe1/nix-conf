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
      drivers = with pkgs; [ ];
    };

    hardware = {
      sane = {
        enable = true;
        extraBackends = with pkgs; [ sane-airscan ];
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}

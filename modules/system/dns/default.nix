{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.system.dns;
in
{
  options.custom.system.dns = with types; {
    enable = mkBoolOpt false "Whether or not to enable creation of dns server.";
  };

  config = mkIf cfg.enable {
    services.bind = {
      enable = true;
      forwarders = [];
      zones = {
        "geek" = {
          master = false;
          masters = [ "202.83.95.229" ];
        };
      };
    };
  };
}


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
        "." = {
          file = "${pkgs.dns-root-data}/root.hints";
          master = true;
        };
      };
    };
  };
}


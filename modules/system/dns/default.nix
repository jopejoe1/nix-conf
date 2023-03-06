{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let
  cfg = config.custom.system.dns;
      zones = {
        "geek" = import ./geek.nix pkgs;
        "glue"  = import ./glue.nix  pkgs;
    };
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
          file = "${pkgs.opennic-dns-root-data}/geek.zone";
        };
        "glue" = {
          master = false;
          masters = [ "195.201.99.61" "168.119.153.26" ];
          file = "${pkgs.opennic-dns-root-data}/glue.zone";
        };
      };
    };
  };
}


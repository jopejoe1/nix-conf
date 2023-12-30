{ config, lib, ... }:

let cfg = config.events."37c3";
in {
  options.events."37c3" = {
    enable = lib.mkEnableOption "Enable settings for the 37c3 event";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.ensureProfiles.profiles = {
      "37C3" = {
        connection = {
          id = "37C3";
          type = "wifi";
          interface-name = "wlan0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "37C3";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          anonymous-identity = "37C3";
          eap = "ttls;";
          identity = "37C3";
          password = "37C3";
          phase2-auth = "mschapv2";
        };
        ipv4 = { method = "auto"; };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
      };
      networking.wireless.networks."37C3".auth = ''
        key_mgmt=WPA-EAP
        eap=TTLS
        identity="37C3"
        password="37C3"
        ca_cert="${
          builtins.fetchurl {
            url = "https://letsencrypt.org/certs/isrgrootx1.pem";
            sha256 =
              "sha256:1la36n2f31j9s03v847ig6ny9lr875q3g7smnq33dcsmf2i5gd92";
          }
        }"
        altsubject_match="DNS:radius.c3noc.net"
        phase2="auth=PAP"
      '';
    };
  };
}

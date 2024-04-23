{ config, pkgs, ...}:

let
  fqdn = "matrix.missing.ninja";
  baseUrl = "https://${fqdn}";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  services.postgresql.enable = true;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "missing.ninja" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "matrix.missing.ninja" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 404;
        '';
        locations."/_matrix".proxyPass = "http://[::1]:8448";
        locations."/_synapse/client".proxyPass = "http://[::1]:8448";
      };
      "element.missing.ninja" = {
        enableACME = true;
        forceSSL = true;
        root = pkgs.element-web.override {
          conf = {
            default_server_config = clientConfig;
          };
        };
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "missing.ninja";
      registration_shared_secret = "";
      public_baseurl = baseUrl;
      listeners = [
        {
          port = 8448;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = true;
            }
          ];
        }
      ];
    };
  };

  services.mautrix-whatsapp = {
    enable = true;
    settings = {
      appservice = {
        database = {
          type = "postgres";
          uri = "postgresql:///mautrix_whatsapp?host=/run/postgresql";
        };
        ephemeral_events = false;
        id = "whatsapp";
      };
      bridge = {
        encryption = {
          allow = true;
          default = true;
          require = true;
        };
        history_sync = {
          request_full_sync = true;
        };
        mute_bridging = true;
        permissions = {
          "missing.ninja" = "user";
        };
        private_chat_portal_meta = true;
        provisioning = {
          shared_secret = "disable";
        };
      };
    };
  };
}

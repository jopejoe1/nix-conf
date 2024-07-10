{ config, pkgs, ... }:

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
    virtualHosts = {
      "missing.ninja" = {
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
      app_service_config_files = [ "/var/lib/matrix-synapse/whatsapp-registration.yaml" ];
      listeners = [
        {
          port = 8448;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
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
          type = "sqlite3";
          uri = "/var/lib/mautrix-whatsapp/mautrix-whatsapp.db";
        };
        ephemeral_events = true;
        id = "whatsapp";
      };
      bridge = {
        encryption = {
          allow = true;
          default = true;
          require = false;
          appservice = true;

        };
        history_sync = {
          request_full_sync = true;
          message_count = -1;
        };
        mute_bridging = true;
        personal_filtering_spaces = true;
        permissions = {
          "*" = "relay";
          "missing.ninja" = "user";
          "@admin:missing.ninja" = "admin";
        };
        private_chat_portal_meta = true;
        whatsapp_thumbnail = true;
        federate_rooms = false;
        caption_in_message = true;
        extev_polls = true;
        cross_room_replies = true;

        provisioning = {
          shared_secret = "disable";
        };
      };
    };
  };
}

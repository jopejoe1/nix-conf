{ config, pkgs, ... }:

let
  fqdn = "matrix.miau.social";
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
  services.nginx = {
    virtualHosts = {
      "miau.social" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "matrix.miau.social" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://unix:${config.services.matrix-continuwuity.settings.global.unix_socket_path}";
      };
      "element.miau.social" = {
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

  systemd.services.nginx.serviceConfig.ProtectHome = false;

  users.groups.continuwuity.members = [ "nginx" ];

  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      unix_socket_path = "/run/continuwuity/continuwuity.sock";
      server_name = "miau.social";
      #registration_token = "NyanNyan";
      #allow_registration = true;
    };
  };
}

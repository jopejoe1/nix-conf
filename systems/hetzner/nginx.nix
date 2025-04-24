{
  config,
  pkgs,
  self,
  lib,
  ...
}:

{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "missing.ninja" = {
        serverAliases = [
          "joens.zone"
          "joens.website"
          "joens.site"
          "joens.online"
          "joens.link"
          "joens.international"
          "joens.family"
          "joens.digital"
          "joens.blog"
          "net0loggy.net"
          #"clan-war.net"
          "net0loggy.de"
          "dtg-c.de"
        ];
        enableACME = true;
        forceSSL = true;
      };
      "webmail.missing.ninja" = {
        serverAliases = [ "joens.email" ];
      };
      "pad.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:3333";
        locations."/socket.io/" = {
          proxyPass = "http://localhost:3333";
          proxyWebsockets = true;
          extraConfig = "proxy_ssl_server_name on;";
        };
      };
      "test.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
      };
      "search.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:8080";
      };
      "ci.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:8000";
      };
      "cache.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass =
          "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
      "hetzner" = {
        forceSSL = false;
        enableACME = false;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:1242";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $host:$server_port;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Server $host;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Upgrade $http_upgrade;
            '';
          };
          "/Api/NLog" = {
            proxyPass = "http://127.0.0.1:1242";
            extraConfig = ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $host:$server_port;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Server $host;
            '';
          };
        };
      };
    };
  };

  services.hedgedoc = {
    enable = true;
    settings = {
      db = {
        dialect = "sqlite";
        torage = "/var/lib/hedgedoc/db.hedgedoc.sqlite";
      };
      domain = "pad.missing.ninja";
      port = 3333;
      useSSL = false;
      protocolUseSSL = true;
    };
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  services.wordpress.webserver = "nginx";
  services.phpfpm.phpOptions = ''
    post_max_size = "64M"
    upload_max_filesize = "64M"
    max_execution_time = 300
    max_input_time = 300
  '';

  services.searx = {
    enable = true;
    runInUwsgi = false;
    settings = {
      server.secret_key = "NotASecret";
    };
    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };
  };
}

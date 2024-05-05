{config, pkgs, self, ...}:

{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "missing.ninja" = {
        serverAliases = [ "joens.zone" "joens.website" "joens.site" "joens.online" "joens.link" "joens.international" "joens.family" "joens.digital" "joens.blog" "net0loggy.net" "clan-war.net" "net0loggy.de" "dtg-c.de" ];
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
          extraConfig =
            "proxy_ssl_server_name on;"
            ;
        };
      };
      "test.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
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

  services.wordpress.webserver = "nginx";
  services.phpfpm.phpOptions = ''
    post_max_size = "64M"
    upload_max_filesize = "64M"
    max_execution_time = 300
    max_input_time = 300
  '';

  services.wordpress.sites."test.missing.ninja" = with self.packages.${config.nixpkgs.hostPlatform.system}; {
    themes = [
      madara
      madara-child
      pkgs.wordpressPackages.themes.twentytwentythree
    ];
    plugins = [
      madara-core
      madara-shortcodes
      option-tree
      option-tree-lean
      widget-logic
    ];
    settings = {
      FORCE_SSL_ADMIN = true;
    };
    extraConfig = ''
      $_SERVER['HTTPS']='on';
    '';
  };
}

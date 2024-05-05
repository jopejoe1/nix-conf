{config, pkgs, ...}:

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

  services.wordpress.sites."test.missing.ninja" =
  let
  madara = pkgs.stdenv.mkDerivation rec {
    name = "madara";
    version = "1.7.4.1";
    src = pkgs.fetchzip {
      url = "file:///var/dl/madara-${version}.zip";
      hash = "";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-child = pkgs.stdenv.mkDerivation rec {
    name = "madara-child";
    version = "1.0.3";
    src = pkgs.fetchzip {
      url = "file:///var/dl/madara-child-${version}.zip";
      hash = "";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-core = pkgs.stdenv.mkDerivation rec {
    name = "madara-core";
    version = "1.7.4.1";
    src = pkgs.fetchzip {
      url = "file:///var/dl/madara-core-${version}.zip";
      hash = "";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-shortcodes = pkgs.stdenv.mkDerivation rec {
    name = "madara-shortcodes";
    version = "1.5.5.9";
    src = pkgs.fetchzip {
      url = "file:///var/dl/madara-shortcodes-${version}.zip";
      hash = "";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  option-tree-lean = pkgs.stdenv.mkDerivation rec {
    name = "option-tree-lean";
    version = "0";
    src = pkgs.fetchzip {
      url = "file:///var/dl/option-tree-lean.zip";
      hash = "";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  in
  {
    themes = [
      madara
      madara-child
    ];
    plugins = [
      madara-core
      madara-shortcodes
      option-tree-lean
    ];
    settings = {
      FORCE_SSL_ADMIN = true;
    };
    extraConfig = ''
      $_SERVER['HTTPS']='on';
    '';
  };
}

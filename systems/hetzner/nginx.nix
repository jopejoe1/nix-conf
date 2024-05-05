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
    src = pkgs.requireFile {
      name = "madara-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-JxfjZLoN6I9twAQMT60Q27CgJg22G7zEU5GDra9rROs=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-child = pkgs.stdenv.mkDerivation rec {
    name = "madara-child";
    version = "1.0.3";
    src = pkgs.requireFile {
      name = "madara-child-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-h9w2TmX1nXaoP27b9DQ1jf6z1hTS5+BWtlz+Fprk5dQ=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-core = pkgs.stdenv.mkDerivation rec {
    name = "madara-core";
    version = "1.7.4.1";
    src = pkgs.requireFile {
      name = "madara-core-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-r22hGCDlVeYTOFlhfKoc3r4TtpZExJ2E2QP9ssRoJco=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-shortcodes = pkgs.stdenv.mkDerivation rec {
    name = "madara-shortcodes";
    version = "1.5.5.9";
    src = pkgs.requireFile {
      name = "madara-shortcodes-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-IW7C5DTzvt3ROFpfB21LY2wmdR45lNj9c8/THHCi6eY=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  option-tree-lean = pkgs.stdenv.mkDerivation rec {
    name = "option-tree-lean";
    version = "0";
    src = pkgs.requireFile {
      name = "option-tree-lean.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-9u+MGdOarNdLtARWiJpw/hsMR9X8r0h5qugGir+amUI=";
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

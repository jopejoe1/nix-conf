{
  config,
  pkgs,
  lib,
  ...
}:

{
  mailserver = {
    enable = true;
    dmarcReporting.enable = true;
    stateVersion = 3;
    fqdn = "mail.missing.ninja";
    x509.useACMEHost = config.mailserver.fqdn;
    domains = [
      "missing.ninja"
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
      "clan-war.net"
      "net0loggy.de"
      "dtg-c.de"
      "joens.email"
      "nyan.social"
      "miau.social"
      "pumkin.social"
    ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "jopejoe1@missing.ninja" = {
        hashedPassword = "$2b$05$ZZk/X.gQqjRc08ej9XTuaO0aVnWjPGWUqo/xYGxHGsMEyDL.Hr8AS";
        aliases = [
          "@missing.ninja"
          "@joens.zone"
          "@joens.website"
          "@joens.site"
          "@joens.online"
          "@joens.link"
          "@joens.international"
          "@joens.family"
          "@joens.digital"
          "@joens.blog"
          "@net0loggy.net"
          "@clan-war.net"
          "@net0loggy.de"
          "@dtg-c.de"
          "@joens.email"
          "@nyan.social"
          "@miau.social"
          "@pumpkin.social"
        ];
      };
    };

    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
      enforced = "body";
    };
  };

  security.acme.certs."mail.missing.ninja".webroot =
    config.security.acme.certs."missing.ninja".webroot;

  services.roundcube = {
    enable = true;
    # this is the url of the vhost, not necessarily the same as the fqdn of
    # the mailserver
    hostName = "webmail.missing.ninja";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  services.radicale = {
    rights = {
      root = {
        user = ".+";
        collection = "";
        permissions = "R";
      };
      principal = {
        user = ".+";
        collection = "{user}";
        permissions = "RW";
      };
      calendars = {
        user = ".+";
        collection = "{user}/[^/]+";
        permissions = "rw";
      };
      shared = {
        user = ".+";
        collection = "shared";
        permissions = "RW";
      };
      shared-items = {
        user = ".+";
        collection = "shared/[^/]+";
        permissions = "rw";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}

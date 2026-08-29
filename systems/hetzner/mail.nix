# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  config,
  pkgs,
  ...
}:

{
  mailserver = {
    enable = true;
    dmarcReporting.enable = true;
    stateVersion = 5;
    fqdn = "mail.missing.ninja";
    enableManageSieve = true;
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
      "joens.email"
      "joens.blog"
      "net0loggy.net"
      "clan-war.net"
      "net0loggy.de"
      "dtg-c.de"
      "joens.email"
      "nyan.social"
      "miau.social"
      "pumpkin.social"
    ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    accounts = {
      "rtk2go@net0loggy.net" = {
        hashedPassword = "$2b$05$fszSLfEWJhMDWY65jwPn1.7IWgk4BKhee02TfGwUU7gSaNJDz1xFC";
      };
      "jopejoe1@missing.ninja" = {
        hashedPassword = "$2b$05$ZZk/X.gQqjRc08ej9XTuaO0aVnWjPGWUqo/xYGxHGsMEyDL.Hr8AS";
        aliases = [
          "@missing.ninja"
          "@joens.email"
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
    };
  };

  # security.acme.certs."mail.missing.ninja".webroot = config.security.acme.certs."missing.ninja".webroot;

  services.roundcube = {
    enable = true;
    # this is the url of the vhost, not necessarily the same as the fqdn of
    # the mailserver
    hostName = "webmail.missing.ninja";
    package = pkgs.roundcube.withPlugins (
      plugins: with plugins; [
        # external plugins to be included
        # https://search.nixos.org/packages?query=roundcubePlugins
        persistent_login
      ]
    );
    # activate plugins
    plugins = [
      "persistent_login"
      "managesieve" # built-in
    ];
    dicts = with pkgs.aspellDicts; [
      # https://search.nixos.org/packages?query=aspellDicts
      en
    ];
    maxAttachmentSize = config.mailserver.messageSizeLimit / 1024 / 1024;
    extraConfig = ''
      $config['imap_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";

      $config['managesieve_host'] = "tls://${config.mailserver.fqdn}";
      $config['managesieve_port'] = 4190;
      $config['managesieve_usetls'] = true;
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

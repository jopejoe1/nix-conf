{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  mailAccounts = config.mailserver.loginAccounts // {
    isa.hashedPassword = "$2b$05$Mzr0MwkCOHUwMl8rM9FKs.Q/9H/sNI8ddC6PdIBCzWBTYweVYgPDO";
  };
  htpasswd = pkgs.writeText "radicale.users" (
    concatStrings (
      flip mapAttrsToList mailAccounts (mail: user: mail + ":" + user.hashedPassword + "\n")
    )
  );

in
{
  services.radicale = {
    enable = true;
    settings = {
      auth = {
        type = "htpasswd";
        htpasswd_filename = "${htpasswd}";
        htpasswd_encryption = "bcrypt";
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "cal.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:5232/";
          extraConfig = ''
            proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass_header Authorization;
          '';
        };
      };
    };
  };
}

{ config, pkgs, lib, ...}:

{
  mailserver = {
    enable = true;
    fqdn = "mail.missing.ninja";
    domains = [ "missing.ninja" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "admin@missing.ninja" = {
        hashedPasswordFile = "/a/file/containing/a/hashed/password";
        aliases = [ "@missing.ninja" ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
}

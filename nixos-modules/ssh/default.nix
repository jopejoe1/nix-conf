{
  config,
  lib,
  ...
}:

let
  cfg = config.jopejoe1.ssh;
in
{
  options.jopejoe1.ssh = {
    enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      banner = "Hackers are in Your System!!!\n";
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
      hostKeys = [
        {
          bits = 4096;
          path = "/var/lib/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}

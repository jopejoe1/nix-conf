{ config, lib, pkgs, self, ... }:

let cfg = config.jopejoe1.ssh;
in {
  options.jopejoe1.ssh = { enable = lib.mkEnableOption "Enable ssh"; };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      banner = "Hackers are in Your System!!!\n";
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };
  };
}


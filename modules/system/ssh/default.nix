{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.system.ssh;
in
{
  options.custom.system.ssh = with types; {
    enable = mkBoolOpt false "Whether or not to enable ssh.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      settings = {
        X11forwarding = true;
        PermitRootLogin = "no";
        passwordAuthentication = false;
        kbdInteractiveAuthentication = false;
      };
    };
    environment.systemPackages = with pkgs; [ sshfs ];
  };
}


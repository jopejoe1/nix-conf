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
      passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
      settings.X11forwarding = true;
      settings.PermitRootLogin = "yes";
    }
    environment.systemPackages = with pkgs; [ sshfs ];
  };
}


{ pkgs, ... }:

{
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      allowSFTP = true;
      settings = {
        X11forwarding = true;
        PermitRootLogin = "no";
        passwordAuthentication = true;
        kbdInteractiveAuthentication = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [ sshfs ];
}



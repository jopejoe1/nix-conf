{ pkgs, ... }:

{
  services.cage.user = "kodi";
  services.cage.program = "${pkgs.kodi-wayland.withPackages (p: with p; [ trakt netflix youtube vfs-sftp ])}/bin/kodi-standalone";
  services.cage.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

  users.extraUsers.kodi.isNormalUser = true;
}



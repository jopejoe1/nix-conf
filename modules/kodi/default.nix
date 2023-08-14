{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      libinput.enable = true;
      desktopManager.kodi = {
        enable = true;
        package = pkgs.kodi-wayland.withPackages (p: with p; [ trakt netflix youtube vfs-sftp ]);
      };

      displayManager.lightdm.enable = true;
      displayManager.lightdm.autoLogin.timeout = 3;

      displayManager.autoLogin = {
        enable = true;
        user = "kodi";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

  users.extraUsers.kodi.isNormalUser = true;
}



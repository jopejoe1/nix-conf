{ config, pkgs, lib, ... }:

{
  jopejoe1 = {
    local.enable = true;
    nix.enable = true;
    user = {
      root.enable = true;
    };
    ssh.enable = true;
  };


  time.timeZone = "Europe/Berlin";
  
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
  
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      forcei686 = true;
    };
  };
}

{ ... }:

{
  imports =  [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  networking.hostName = "inugami";

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
  };

  hardware.raspberry-pi."4".fkms-3d.enable = true;
}

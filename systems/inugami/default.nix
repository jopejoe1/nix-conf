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
}

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  jopejoe1 = {
    audio = { enable = true; };
    bluetooth.enable = true;
    local.enable = true;
    jopejoe1.enable = true;
    nix.enable = true;
    root.enable = true;
  };

  networking = { hostName = "tuny"; };
  boot.loader.grub.device = "/dev/sda";

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [ mixxx ];

  time.timeZone = "Europe/Berlin";
}

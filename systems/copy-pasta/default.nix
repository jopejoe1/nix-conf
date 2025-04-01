{
  config,
  pkgs,
  lib,
  nixos-hardware,
  self,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel
    #nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc
    self.inputs.srvos.nixosModules.desktop
  ];

  boot.loader.grub.devices = [ "/dev/sda" ];

  #facter.reportPath = ./facter.json;

  jopejoe1 = {
    audio = {
      enable = true;
    };
    local.enable = true;
    nix.enable = true;
    plasma.enable = true;
    ssh.enable = true;
    sway.enable = true;
    gui.enable = true;
    keyboard = {
      enable = true;
      layout = "de";
    };
    user = {
      jopejoe1.enable = true;
      root.enable = true;
    };
  };

  time.timeZone = "Europe/Berlin";

  networking.wireless.enable = false;

  environment.systemPackages = with pkgs; [
    picard
    asunder
    (ffmpeg-full.override {
      #withTensorflow = true;
      withUnfree = true;
    })
  ];

  programs = {
    xwayland.enable = true;
  };
}

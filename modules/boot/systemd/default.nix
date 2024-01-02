{ config, lib, ... }:

let cfg = config.jopejoe1.boot.systemd;
in {
  options.jopejoe1.boot.systemd = {
    enable = lib.mkEnableOption "Enable Systemd boot";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false;
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };
    };
  };
}

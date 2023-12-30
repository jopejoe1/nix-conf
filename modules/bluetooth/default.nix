{ config, lib, ... }:

let cfg = config.jopejoe1.bluetooth;
in {
  options.jopejoe1.bluetooth = {
    enable = lib.mkEnableOption "Enable Bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}

{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.hardware.bluetooth;
in
{
  options.custom.hardware.bluetooth = with types; {
    enable = mkBoolOpt false "Whether or not to enable bluetooth";
  };

  config = mkIf cfg.enable {

    hardware.bluetooth.enable = true;
    hardware.bluetooth.hsphfpd.enable = !config.services.pipewire.wireplumber.enable;
    hardware.bluetooth.powerOnBoot = true;

  };
}

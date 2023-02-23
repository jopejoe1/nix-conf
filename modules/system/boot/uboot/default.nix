{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.system.boot.uboot;
in
{
  options.custom.system.boot.uboot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting on uboot system.";
  };

  config = mkIf cfg.enable {
    boot = {
    # Boot loader configutation
      loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
        grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
        generic-extlinux-compatible.enable = true;
      };
    };
  };
}

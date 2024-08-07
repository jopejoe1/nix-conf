{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.auto-update;
in
{
  options.jopejoe1.auto-update = {
    enable = lib.mkEnableOption "Enable Auto-Updates";
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      randomizedDelaySec = "30min";
      flake =
        if config.services.archisteamfarm.enable then
          "$(${pkgs.coreutils}/bin/rm -rf /var/lib/update-repo && ${lib.getExe pkgs.git} clone git@codeberg.org:jopejoe1/nix-conf.git /var/lib/update-repo -q --depth=1 && ${lib.getExe pkgs.git} -C /var/lib/update-repo am /home/jopejoe1/.config/patches/0001-add-liscense.patch  -q)/var/lib/update-repo"
        else
          "github:jopejoe1/nix-conf";
      dates = "hourly";
    };
  };
}

{ pkgs, config, ... }:

{
  system.autoUpgrade = {
    enable = true;
    randomizedDelaySec = "30min";
    flake = if config.services.archisteamfarm.enable then "$(${pkgs.coreutils}/bin/rm -rf /var/lib/update-repo && ${pkgs.git}/bin/git clone git@codeberg.org:jopejoe1/nix-conf.git /var/lib/update-repo -q --depth=1 && ${pkgs.git}/bin/git -C /var/lib/update-repo am /home/jopejoe1/.config/patches/0001-add-liscense.patch  -q)/var/lib/update-repo" else "github:jopejoe1/nix-conf";
    dates = "hourly";
  };
}

{ pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    randomizedDelaySec = "30min";
    flake = "$(${pkgs.coreutils}/bin/rm -rf /var/lib/update-repo && ${pkgs.git}/bin/git clone git@codeberg.org:jopejoe1/nix-conf.git /var/lib/update-repo -q && ${pkgs.git}/bin/git -C /var/lib/update-repo am /home/jopejoe1/.config/patches/0001-add-liscense.patch  -q)/var/lib/update-repo";
    dates = "hourly";
  };
}

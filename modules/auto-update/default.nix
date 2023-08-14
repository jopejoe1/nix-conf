{ ... }:

{
  system.autoUpgrade = {
    enable = true;
    randomizedDelaySec = "30min";
    flake = "git+https://codeberg.org/jopejoe1/nix-conf.git";
    dates = "hourly";
  };
}

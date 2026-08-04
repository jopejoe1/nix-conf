# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  config,
  lib,
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
      flake = "github:jopejoe1/nix-conf";
      dates = "hourly";
    };
  };
}

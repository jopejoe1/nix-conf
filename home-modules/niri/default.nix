# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  lib,
  pkgs,
  config,
  nixosConfig,
  ...
}:

let
  cfg = config.jopejoe1.niri;
in
{
  options.jopejoe1.niri = {
    enable = lib.mkEnableOption "setting up niri";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = lib.getExe pkgs.alacritty;
          layer = "overlay";
        };
      };
    };
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
    programs.swaylock.enable = true;
  };
}

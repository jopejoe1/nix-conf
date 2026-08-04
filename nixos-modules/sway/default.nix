# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.jopejoe1.sway;
in
{
  options.jopejoe1.sway = {
    enable = lib.mkEnableOption "Enable Sway";
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
    };
  };
}

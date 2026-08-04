# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.jopejoe1.boot.systemd;
in
{
  options.jopejoe1.boot.systemd = {
    enable = lib.mkEnableOption "Enable Systemd boot";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
          editor = false;
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
    };
  };
}

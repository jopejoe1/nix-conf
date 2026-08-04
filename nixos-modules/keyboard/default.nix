# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  config,
  lib,
  ...
}:

let
  cfg = config.jopejoe1.keyboard;
in
{
  options.jopejoe1.keyboard = {
    enable = lib.mkEnableOption "Enable Keyboard";
    layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard Layout.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        xkb.layout = cfg.layout;
      };
    };
    console = {
      enable = true;
      keyMap = cfg.layout;
    };
  };
}

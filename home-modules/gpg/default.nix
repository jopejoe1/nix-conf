# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  config,
  lib,
  ...
}:

let
  cfg = config.jopejoe1.gpg;
in
{
  options.jopejoe1.gpg = {
    enable = lib.mkEnableOption "setup gpg";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };
    };
  };
}

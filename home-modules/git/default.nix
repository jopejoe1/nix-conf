# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.git;
in
{
  options.jopejoe1.git = {
    enable = lib.mkEnableOption "setting up git";
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit.enable = true;
    programs.git = {
      enable = true;
      package = pkgs.git;
      signing.format = null;
      settings = {
        user = {
          email = "jopejoe1@missing.ninja";
          name = "jopejoe1";
        };
        core = {
          whitespace = [
            "blank-at-eol"
            "blank-at-eof"
            "space-before-tab"
          ];
        };
      };
    };
  };
}

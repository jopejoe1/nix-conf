# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  treefmt,
  nixfmt,
}:

treefmt.withConfig {
  runtimeInputs = [
    nixfmt
  ];
  settings = {
    tree-root-file = ".git/index";
    formatter = {
      nixfmt = {
        command = "nixfmt";
        includes = [ "*.nix" ];
      };
    };
  };
}

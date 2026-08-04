# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

let
  npins = import ./npins { };
  pkgs = import npins.nixpkgs { };
  patches = {
    nixpkgs = [
      (pkgs.fetchpatch {
        url = "https://github.com/jopejoe1/nixpkgs/commit/fc2b06c28c5aa785965648fdc2bedd0d384f7130.patch";
        hash = "sha256-/jXnO8V++p3D+aafCMqPBSpaUFbdeed11YoKq6ceJpU=";
      })
    ];
  };
  inputs = builtins.mapAttrs (
    name: value:
    let
      new_value = value { inherit pkgs; };
    in
    new_value
    // pkgs.lib.optionalAttrs (patches ? ${name}) rec {
      outPath = pkgs.applyPatches {
        src = new_value.outPath;
        patches = patches.${name};
      };
      hash = outPath.outputHash;
      patchUrls = map (value: value.url) outPath.patches;
    }
  ) npins;
in
inputs

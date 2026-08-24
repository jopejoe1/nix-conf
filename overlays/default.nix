# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

final: prev:
let
  inherit (final) callPackage;
in
{
  jopejoe1 = {
    resize = callPackage ./resize { };
    fmt = callPackage ./fmt { };
  };

  # fix random flakes that make use of this
  xcb-util-cursor = final.libxcb-cursor;
  xorg.lndir = final.lndir;

  nixos-anywhere = prev.nixos-anywhere.overrideAttrs (finalAttrs: {
    src = prev.fetchFromGitHub {
      owner = "nix-community";
      repo = "nixos-anywhere";
      rev = "230edbb60ce3d47d71a283e492bd444afd634935";
      hash = "sha256-AO54aUSnnVGk1jrGWa7iI75xrRo17RAcMfchrbLtZ2A=";
    };
  });
}

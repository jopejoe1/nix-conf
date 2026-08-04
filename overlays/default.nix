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
}

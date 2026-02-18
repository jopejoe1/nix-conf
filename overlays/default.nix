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

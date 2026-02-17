final: prev:
let
  inherit (final) callPackage;
in
{
  jopejoe1 = {
    resize = callPackage ./resize { };
    fmt = callPackage ./fmt { };
  };
}

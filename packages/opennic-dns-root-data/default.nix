{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "opennic-dns-root-data";

  buildCommand = ''
    mkdir $out
    echo "${lib.toString "example.com" (import ./geek.nix { inherit dns; })}" > $out/geek.zone
    echo "${lib.toString "example.com" (import ./geek.nix { inherit dns; })}" > $out/glue.zone
  '';

  meta = with lib; {
    description = "DNS root data including root zone for openic";
  };
}

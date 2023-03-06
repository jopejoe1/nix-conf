{ stdenv, lib, dns }:

stdenv.mkDerivation {
  pname = "openic-dns-root-data";

  buildCommand = ''
    mkdir $out
    echo "${dns.lib.toString "example.com" (import ./geek.nix { inherit dns; })}" > $out/geek.zone
    echo "${dns.lib.toString "example.com" (import ./geek.nix { inherit dns; })}" > $out/glue.zone
  '';

  meta = with lib; {
    description = "DNS root data including root zone for openic";
  };
}

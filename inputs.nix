let
  npins = import ./npins { };
  pkgs = import npins.nixpkgs { };
  patches = {
    nixpkgs = [
      (pkgs.fetchpatch {
        url = "https://github.com/NixOS/nixpkgs/pull/493229.patch";
        hash = "sha256-XbeNEkmilAo1BEAKVGpeIRHuqvYSURQ9qKByb0pSesY=";
      })
    ];
    niri = [
      (pkgs.fetchpatch {
        url = "https://github.com/jopejoe1/niri-flake/commit/706697d932f737483d39bd70ffcc52c3ab7d4021.patch";
        hash = "sha256-2v1sXl3+5rdS0aiF1/npiA/GvlMsDnIPfgnpGkIhG70=";
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

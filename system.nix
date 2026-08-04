# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

let
  inputs = import ./inputs.nix;
  nixpkgs = inputs.nixpkgs;
  lib = import "${nixpkgs}/lib";

  systems = lib.mapAttrs (
    hostname: type:
    import "${nixpkgs}/nixos" {
      specialArgs = {
        inherit systems;
        npins = inputs;
      };
      configuration.imports = [
        ./systems/${hostname}
        ./nixos-modules
        {
          system.stateVersion = "24.05";
          networking.hostName = hostname;
          nixpkgs = {
            hostPlatform = {
              system = (lib.importJSON ./systems/${hostname}/facter.json).system;
            };
          };
        }
      ];
    }
  ) (lib.readDir ./systems);
in
systems

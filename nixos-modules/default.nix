# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  npins,
  lib,
  ...
}:

let
  utils = import (npins.dns + "/utils") { inherit lib; };
in
{
  imports = [
    # Internel modules
    ./asf
    ./audio
    ./auto-update
    ./boot
    ./doc
    ./events
    ./kodi
    ./keyboard
    ./local
    ./minecraft-server
    ./moodle-dl
    ./nix
    ./plasma
    ./printing
    ./ssh
    ./steam
    ./sway
    ./users
    ./zerotierone
    ./common
    # External modules
    (npins.disko + "/module.nix")
    (npins.home-manager + "/nixos")
    (npins.sops-nix + "/modules/sops")
    (npins.disko + "/module.nix")
    (npins.snm + "/")
    (import (npins.dns + "/modules/nixos.nix") {
      inherit utils;
    })

    # pkgs extensions
    {
      nixpkgs.overlays = [
        (import ../overlays)
        (import (npins.firefox-addons + "/overlay.nix"))
        (x: y: {
          wrappers = import (npins.wrappers + "/") { inherit (y) lib pkgs; };
        })
      ];
      home-manager.sharedModules = [
        ../home-modules
      ];
    }
  ];
}

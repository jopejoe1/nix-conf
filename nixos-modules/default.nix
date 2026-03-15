{
  fpkgs,
  npins,
  ...
}:
{
  imports =
    let
      niri = fpkgs.applyPatches {
        src = (npins.niri { pkgs = fpkgs; });
        patches = [
          (fpkgs.fetchpatch {
            url = "https://github.com/jopejoe1/niri-flake/commit/706697d932f737483d39bd70ffcc52c3ab7d4021.patch";
            hash = "sha256-2v1sXl3+5rdS0aiF1/npiA/GvlMsDnIPfgnpGkIhG70=";
          })
        ];
      };
    in
    [
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
      (npins.disko { pkgs = fpkgs; } + "/module.nix")
      (npins.home-manager { pkgs = fpkgs; } + "/nixos")
      (npins.sops-nix { pkgs = fpkgs; } + "/modules/sops")
      (npins.disko { pkgs = fpkgs; } + "/module.nix")
      (niri + "/modules/nixos.nix")
      (npins.snm { pkgs = fpkgs; } + "/")

      # pkgs extensions
      {
        nixpkgs.overlays = [
          (import ../overlays)
          (import (npins.firefox-addons { pkgs = fpkgs; } + "/overlay.nix"))
        ];
        home-manager.sharedModules = [
          ../home-modules
        ];
      }
    ];
}

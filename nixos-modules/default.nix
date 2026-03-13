{
  fpkgs,
  npins,
  ...
}:
{
  imports =
    let
      niri = (builtins.getFlake (npins.niri { }).url);
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
      niri.nixosModules.niri
      (npins.snm { pkgs = fpkgs; } + "/")

      # pkgs extensions
      {
        nixpkgs.overlays = [
          (import ../overlays)
          (import (npins.firefox-addons { pkgs = fpkgs; } + "/overlay.nix"))
          niri.overlays.niri
        ];
        home-manager.sharedModules = [
          ../home-modules
        ];
      }
    ];
}

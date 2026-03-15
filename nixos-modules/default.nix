{
  npins,
  ...
}:
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
    (npins.niri + "/modules/nixos.nix")
    (npins.snm + "/")

    # pkgs extensions
    {
      nixpkgs.overlays = [
        (import ../overlays)
        (import (npins.firefox-addons + "/overlay.nix"))
      ];
      home-manager.sharedModules = [
        ../home-modules
      ];
    }
  ];
}

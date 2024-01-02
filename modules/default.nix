{ self, ... }:

{
  imports = [
    ./asf
    ./audio
    ./auto-update
    ./bluetooth
    ./boot
    ./events
    ./kodi
    ./local
    ./minecraft-server
    ./moodle-dl
    ./nix
    ./overlays
    ./plasma
    ./plasma/6.nix
    ./printing
    ./repo-sync
    ./steam
    ./users
    self.inputs.home-manager.nixosModules.home-manager
    self.inputs.kde2nix.nixosModules.plasma6
    self.inputs.nur.nixosModules.nur
  ];
}

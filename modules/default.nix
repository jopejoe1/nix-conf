{ self, ... }:

{
  imports = [
    ./asf
    ./audio
    ./auto-update
    ./bluetooth
    ./local
    ./minecraft-server
    ./moodle-dl
    ./nix
    ./plasma
    ./plasma/6.nix
    ./printing
    ./repo-sync
    ./steam
    ./users
    self.inputs.kde2nix.nixosModules.plasma6
    self.inputs.nur.nixosModules.nur
    self.inputs.home-manager.nixosModules.home-manager
  ];
}

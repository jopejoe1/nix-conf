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
    ./keyboard
    ./local
    ./minecraft-server
    ./moodle-dl
    ./nix
    ./plasma
    ./plasma/6.nix
    ./printing
    ./repo-sync
    ./ssh
    ./steam
    ./sway
    ./users
    ../upstream
    self.inputs.home-manager.nixosModules.home-manager
    self.inputs.kde2nix.nixosModules.plasma6
    self.inputs.nixos-generators.nixosModules.all-formats
  ];
}

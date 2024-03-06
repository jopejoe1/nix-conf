{ self, ... }:

{
  imports = [
    ./asf
    ./audio
    ./auto-update
    ./bluetooth
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
    ./plasma/6.nix
    ./printing
    ./repo-sync
    ./ssh
    ./steam
    ./sway
    ./users
    ./zerotierone
    ../upstream
    self.inputs.home-manager.nixosModules.home-manager
    #self.inputs.disko.nixosModules.disko
    self.inputs.nixos-generators.nixosModules.all-formats
  ];
}

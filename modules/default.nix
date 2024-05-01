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
    ./printing
    ./repo-sync
    ./ssh
    ./steam
    ./sway
    ./users
    ./zerotierone
    ../upstream
    self.inputs.disko.nixosModules.disko
    self.inputs.home-manager.nixosModules.home-manager
    self.inputs.nixos-generators.nixosModules.all-formats
    self.inputs.sops-nix.nixosModules.sops
  ];
}

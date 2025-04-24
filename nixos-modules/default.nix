{ self, ... }:

{
  imports = [
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
    ./repo-sync
    ./ssh
    ./steam
    ./sway
    ./users
    ./zerotierone
    self.inputs.disko.nixosModules.disko
    self.inputs.home-manager.nixosModules.home-manager
    self.inputs.sops-nix.nixosModules.sops
    self.inputs.nixos-facter-modules.nixosModules.facter
  ];
}

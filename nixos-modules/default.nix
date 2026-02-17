self:
{
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
    # External modules
    self.inputs.disko.nixosModules.disko
    self.inputs.home-manager.nixosModules.home-manager
    self.inputs.sops-nix.nixosModules.sops
    self.inputs.niri.nixosModules.niri
    self.inputs.snm.nixosModules.mailserver
    # pkgs extensions
    {
      nixpkgs.overlays = [
        self.outputs.overlays.default
        self.inputs.firefox-addons.overlays.default
        self.inputs.niri.overlays.niri
      ];
      home-manager.sharedModules = [
        self.outputs.homeManagerModules.default
      ];
    }
  ];
}

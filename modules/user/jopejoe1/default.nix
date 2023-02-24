{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.user.jopejoe1;
in
{
  options.custom.user.jopejoe1 = with types; {
    enable = mkBoolOpt false "Enable the user jopejoe1";
  };

  config = mkIf cfg.enable {
    users.users.jopejoe1 = {
      isNormalUser = true;
      description = "jopejoe1 🚫";
      initialPassword = "password";
      openssh.authorizedKeys.keys = [];
      extraGroups = [ "wheel"]
        ++ lib.optionals config.custom.hardware.printing.enable [ "scanner" "lp"]
        ++ lib.optional config.networking.networkmanager.enable "networkmanger";
      packages = with pkgs; [
        kate
        carla
        xdg-ninja
        ark
      ];
    };

    home-manager.users.jopejoe1 = import ./home.nix;
    home-manager.users.jopejoe1.home.stateVersion = config.system.stateVersion;
  };
}

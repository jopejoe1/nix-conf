{ config, lib, ... }:

let
  cfg = config.jopejoe1.user.root;
in
{
  options.jopejoe1.user.root = {
    enable = lib.mkEnableOption "Enable root user";
  };

  config = lib.mkIf cfg.enable {
    users.users.root = {
      initialHashedPassword = "$2b$05$Uk84TY/RHlH8DIigUlFYjeorjTlCMEY9wN2pAcw5BLaPoc7dKiSsC";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8oyMpS2hK3gQXyHIIVS6oilgMpemLmfhKKJ6RBMwUh"
      ];
    };
    home-manager.users.root = {
      home = {
        username = config.users.users.root.name;
        homeDirectory = config.users.users.root.home;
        stateVersion = config.system.stateVersion;
      };
      jopejoe1 = {
        common = {
          enable = true;
          gui = config.jopejoe1.gui.enable;
          fonts = {
            serif = config.fonts.fontconfig.defaultFonts.serif;
            sansSerif = config.fonts.fontconfig.defaultFonts.sansSerif;
            monospace = config.fonts.fontconfig.defaultFonts.monospace;
            emoji = config.fonts.fontconfig.defaultFonts.emoji;
          };
        };
        git.enable = true;
        direnv.enable = true;
      };
    };
  };
}

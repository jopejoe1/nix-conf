{ config, lib, ... }:

let cfg = config.jopejoe1.root;
in {
  options.jopejoe1.root = { enable = lib.mkEnableOption "Enable root user"; };

  config = lib.mkIf cfg.enable {
    users.users.root = {
      initialPassword = "password";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8oyMpS2hK3gQXyHIIVS6oilgMpemLmfhKKJ6RBMwUh johannes@joens.email"
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


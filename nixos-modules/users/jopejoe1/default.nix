{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.user.jopejoe1;
in
{
  options.jopejoe1.user.jopejoe1 = {
    enable = lib.mkEnableOption "Enable jopejoe1 user";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
    users.users.jopejoe1 = {
      isNormalUser = true;
      shell = pkgs.nushell;
      description = "jopejoe1";
      hashedPassword = "$2b$05$Uk84TY/RHlH8DIigUlFYjeorjTlCMEY9wN2pAcw5BLaPoc7dKiSsC";
      extraGroups = [
        "wheel"
        "networkmanager"
        "pipewire"
        "audio"
        "video"
        "adbusers"
        "dialout"
      ];
      uid = 1000;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8oyMpS2hK3gQXyHIIVS6oilgMpemLmfhKKJ6RBMwUh johannes@joens.email"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3pKtvhOOjG1pGJq7cVHS5uWy5IP8y1Ra/ENpmJcqOe root@zap"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFEcNAVRN66mfKmaCpxs++0094Eh4mqXkUwDPZPkIIBB johannes@joens.email"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZDUoC+1lNR2JTY1Q+vhXpuLmKMdVl2OMFLVbQ3cGkw jopejoe1@kuraokami"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKm2igbJ+Ke+dJO3r7wp5ZTreHqC39Sjctca119Bl2yc jopejoe1@zap"
      ];
      packages =
        with pkgs;
        [ ]
        ++ lib.optionals config.jopejoe1.gui.enable [
          libsForQt5.kate
          libsForQt5.ark
          element-desktop
          mumble

          # Theming
          catppuccin-kvantum
          catppuccin-kde
          #catppuccin-gtk
          tela-icon-theme
          vesktop
        ];
    };
    home-manager.users.jopejoe1 = {
      home = {
        username = config.users.users.jopejoe1.name;
        homeDirectory = config.users.users.jopejoe1.home;
        stateVersion = config.system.stateVersion;
      };
      programs.nushell = {
        enable = true;
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
        users.jopejoe1.enable = true;
      };
    };
  };
}

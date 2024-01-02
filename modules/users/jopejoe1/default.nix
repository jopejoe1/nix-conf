{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.jopejoe1;
in {
  options.jopejoe1.jopejoe1 = {
    enable = lib.mkEnableOption "Enable jopejoe1 user";
  };

  config = lib.mkIf cfg.enable {
    users.users.jopejoe1 = {
      isNormalUser = true;
      description = "Johannes Jöns";
      initialPassword = "password";
      extraGroups = [ "wheel" "networkmanager" "pipewire" "audio" ];
      uid = 1000;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8oyMpS2hK3gQXyHIIVS6oilgMpemLmfhKKJ6RBMwUh johannes@joens.email"
      ];
      packages = with pkgs;
        [ libsForQt5.kate libsForQt5.ark texlive.combined.scheme-full ]
        ++ lib.optionals (config.system == "x86_64-linux") [
          discord
          lutris
          bottles
        ];
    };
    home-manager.users.jopejoe1 = {
      home = {
        username = config.users.users.jopejoe1.name;
        homeDirectory = config.users.users.jopejoe1.home;
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
        firefox.enable = true;
      };
    };
  };
}

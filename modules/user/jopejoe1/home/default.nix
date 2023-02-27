{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let
  cfg = config.custom.user.jopejoe1.home;
  hcfg = config.home-manager.users.jopejoe1;
in
{
  options.custom.user.jopejoe1.home = with types; {
    enable = mkBoolOpt false "Enable the home-manger for jopejoe1";
  };

  config = mkIf cfg.enable {
    home-manager.users.jopejoe1 = {
      home = {
        # Basic information for home-manager
        username = "jopejoe1";
        homeDirectory = "/home/${hcfg.home.username}";

        # Enviroment variables
        sessionVariables = {
          XCOMPOSECACHE = "${hcfg.xdg.cacheHome}/X11/xcompos";
          XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
        };

        stateVersion = config.system.stateVersion;
      };

      accounts.email.accounts = {
        main = {
          address = "johannes@joens.email";
          flavor = "gmail.com";
          primary = true;
          realName = "Johannes Joens";
          thunderbird.enable = true;
        };
      };

      # XDG base dirs
      xdg = {
        enable = true;
        mime.enable = true;
        cacheHome = "${hcfg.home.homeDirectory}/.cache";
        configHome = "${hcfg.home.homeDirectory}/.config";
        dataHome = "${hcfg.home.homeDirectory}/.local/share";
        stateHome = "${hcfg.home.homeDirectory}/.local/state";
        userDirs = {
          enable = true;
          createDirectories = false;
          desktop = "${hcfg.home.homeDirectory}/Desktop";
          documents = "${hcfg.home.homeDirectory}/Documents";
          download = "${hcfg.home.homeDirectory}/Downloads";
          music = "${hcfg.home.homeDirectory}/Music";
          pictures = "${hcfg.home.homeDirectory}/Pictures";
          publicShare = "${hcfg.home.homeDirectory}/Public";
          templates = "${hcfg.home.homeDirectory}/Templates";
          videos = "${hcfg.home.homeDirectory}/Videos";
        };
      };
    };
  };
}

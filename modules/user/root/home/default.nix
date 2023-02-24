{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.user.root.home;
let hcfg = config.home-manager.users.root;
in
{
  options.custom.user.root.home = with types; {
    enable = mkBoolOpt false "Enable the home-manger for root";
  };

  config = mkIf cfg.enable {
    home-manager.users.root = {
      home = {
        # Basic information for home-manager
        username = "root";
        homeDirectory = "/${hcfg.home.username}";

        # Enviroment variables
        sessionVariables = {
          XCOMPOSECACHE = "${hcfg.xdg.cacheHome}/X11/xcompos";
          XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
        };

        stateVersion = config.system.stateVersion;
      };

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

      programs = {
        home-manager.enable = true;
        git = {
          enable = true;
          package = pkgs.gitAndTools.gitFull;
          userEmail = "johannes@joens.email";
          userName = "jopejoe1";
        };
        bash = {
          enable = true;
          historyFile = "${hcfg.xdg.stateHome}/bash/history";
          shellAliases = {
            gc = "sudo nix store gc";
            rb = "sudo nix flake update /etc/nixos/ && sudo nixos-rebuild switch";
          };
        };
        zsh.shellAliases = hcfg.programs.bash.shellAliases;
        fish.shellAbbrs = hcfg.programs.bash.shellAliases;
      };
    };
  };
}

{ config, pkgs, ... }:

let cfg = config.home-manager.users.root;
in
{
  home-manager.users.root = {
    home = {
      # Basic information for home-manager
      username = "root";
      homeDirectory = "/${cfg.home.username}";

      # Enviroment variables
      sessionVariables = {
        XCOMPOSECACHE = "${cfg.xdg.cacheHome}/X11/xcompos";
        XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      };

      stateVersion = config.system.stateVersion;
    };

    xdg = {
      enable = true;
      mime.enable = true;
      cacheHome = "${cfg.home.homeDirectory}/.cache";
      configHome = "${cfg.home.homeDirectory}/.config";
      dataHome = "${cfg.home.homeDirectory}/.local/share";
      stateHome = "${cfg.home.homeDirectory}/.local/state";
      userDirs = {
        enable = true;
        createDirectories = false;
        desktop = "${cfg.home.homeDirectory}/Desktop";
        documents = "${cfg.home.homeDirectory}/Documents";
        download = "${cfg.home.homeDirectory}/Downloads";
        music = "${cfg.home.homeDirectory}/Music";
        pictures = "${cfg.home.homeDirectory}/Pictures";
        publicShare = "${cfg.home.homeDirectory}/Public";
        templates = "${cfg.home.homeDirectory}/Templates";
        videos = "${cfg.home.homeDirectory}/Videos";
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
        historyFile = "${cfg.xdg.stateHome}/bash/history";
        shellAliases = {
          gc = "sudo nix store gc";
          rb = "sudo nix flake update /etc/nixos/ && sudo nixos-rebuild switch";
        };
      };
      zsh.shellAliases = cfg.programs.bash.shellAliases;
      fish.shellAbbrs = cfg.programs.bash.shellAliases;
    };
  };
}

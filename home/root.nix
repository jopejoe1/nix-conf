{ config, pkgs, ... }:

{
  home = {
    # Basic information for home-manager
    username = "root";
    homeDirectory = "/${config.home.username}";
    
    # Enviroment variables
    sessionVariables = {
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompos";
      XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    };

    # Do not change this version unless 100% sure updatet evrything to the new version
    stateVersion = "23.05";
  };

  xdg = {
    enable = true;
    mime.enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
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
      historyFile = "${config.xdg.stateHome}/bash/history";
      shellAliases = {
        gc = "sudo nix store gc";
        rb = "sudo nix flake update /etc/nixos/ && sudo nixos-rebuild switch";
      };
    };
    zsh.shellAliases = config.programs.bash.shellAliases;
    fish.shellAbbrs = config.programs.bash.shellAliases;
  };
}

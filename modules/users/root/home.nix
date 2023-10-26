{ config, pkgs, ... }:

let hcfg = config.home-manager.users.root;
in {
  home-manager.users.root = {
    home = {
      # Basic information for home-manager
      username = "root";
      homeDirectory = "/${hcfg.home.username}";

      # Enviroment variables
      sessionVariables = {
        XCOMPOSECACHE = "${hcfg.xdg.cacheHome}/X11/xcompos";
        XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
        ANDROID_HOME = "${hcfg.xdg.dataHome}/android";
        CUDA_CACHE_PATH = "${hcfg.xdg.cacheHome}/nv";
        GRADLE_USER_HOME = "${hcfg.xdg.dataHome}/gradle";
        KODI_DATA = "${hcfg.xdg.dataHome}/kodi";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${hcfg.xdg.configHome}/java";
        WINEPREFIX = "${hcfg.xdg.dataHome}/wine";
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
        createDirectories = true;
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
        package = pkgs.git;
        userEmail = "johannes@joens.email";
        userName = "jopejoe1";
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      bash = {
        enable = true;
        historyFile = "${hcfg.xdg.stateHome}/bash/history";
        shellAliases = {
          gc = "nix store gc";
          rb = "git -C /etc/nixos pull && nix flake update /etc/nixos/ && sudo nixos-rebuild switch --impure && git -C /etc/nixos add . && git -C /etc/nixos commit -m 'Updated flake.lock' && git -C /etc/nixos push";
        };
      };
      zsh.shellAliases = hcfg.programs.bash.shellAliases;
      fish.shellAbbrs = hcfg.programs.bash.shellAliases;

    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.common;
in
{
  options.jopejoe1.common = {
    enable = lib.mkEnableOption "Enable Common Homanger settings";
    gui = lib.mkEnableOption "Graphical programms";
    fonts = {
      monospace = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      sansSerif = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      serif = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };

      emoji = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompos";
        XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
        ANDROID_HOME = "${config.xdg.dataHome}/android";
        CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
        GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
        KODI_DATA = "${config.xdg.dataHome}/kodi";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
        WINEPREFIX = "${config.xdg.dataHome}/wine";
      };
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
        createDirectories = true;
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
    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
    gtk.enable = true;
    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk.iconTheme.package = pkgs.tela-icon-theme;
    gtk.iconTheme.name = "Tela-purple-dark";
  };
}

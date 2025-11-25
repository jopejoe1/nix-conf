{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jopejoe1.git;
in
{
  options.jopejoe1.git = {
    enable = lib.mkEnableOption "Enable Git";
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit.enable = true;
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "jopejoe1@missing.ninja";
          name = "jopejoe1";
        };
        aliases = {
          tug = [ "bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-" ];
        };
      };
    };
    programs.git = {
      enable = true;
      package = pkgs.git;
      userEmail = "jopejoe1@missing.ninja";
      userName = "jopejoe1";
      extraConfig = {
        core = {
          whitespace = [
            "blank-at-eol"
            "blank-at-eof"
            "space-before-tab"
          ];
        };
      };
    };
  };
}

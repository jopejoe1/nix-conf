{
  lib,
  config,
  ...
}:

{
  options.jopejoe1.jj = {
    enable = lib.mkEnableOption "setting up jj";
  };

  config = lib.mkIf config.jopejoe1.jj.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "jopejoe1@missing.ninja";
          name = "jopejoe1";
        };
        aliases = {
          tug = [
            "bookmark"
            "move"
            "--from"
            "heads(::@- & bookmarks())"
            "--to"
            "@-"
          ];
          llog = [
            "log"
            "--revisions"
            "@ | ancestors(trunk()..(visible_heads()), 2) | trunk()"
          ];
        };
      };
    };
  };
}

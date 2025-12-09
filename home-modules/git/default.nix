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
          llog = [ "log" "--revisions" "@ | ancestors(trunk()..(visible_heads()), 2) | trunk()" ];
        };
      };
    };
    programs.helix = {
      enable = true;
      defaultEditor = true;
      languages = {
        language-server = {
          vuels = {
            command = lib.getExe pkgs.vue-language-server;
          };
          typescript-language-server = {
            command = lib.getExe pkgs.typescript-language-server;
          };
          rust-analyzer = {
            command = lib.getExe pkgs.rust-analyzer;
          };
          vscode-json-language-server = {
            command = lib.getExe pkgs.vscode-json-languageserver;
          };
          vscode-css-language-server = {
            command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
          };
          vscode-html-language-server = {
            command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
          };
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

{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.jopejoe1.helix.enable = lib.mkEnableOption "settup helix";

  config = lib.mkIf config.jopejoe1.helix.enable {
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
          nixd = {
            command = lib.getExe pkgs.nixd;
          };
          bash-language-server = {
            command = lib.getExe pkgs.bash-language-server;
          };
          texlab = {
            command = lib.getExe pkgs.texlab;
          };
          clangd = {
            command = lib.getExe' pkgs.clang-tools "clangd";
          };
          docker-compose-langserver = {
            command = lib.getExe pkgs.docker-compose-language-service;
          };
          yaml-language-server = {
            command = lib.getExe pkgs.yaml-language-server;
          };
          docker-langserver = {
            command = lib.getExe pkgs.dockerfile-language-server;
          };
          asm-lsp = {
            command = lib.getExe pkgs.asm-lsp;
          };
          haskell-language-server = {
            command = lib.getExe' pkgs.haskell-language-server "haskell-language-server-wrapper";
          };
          mesonlsp = {
            command = lib.getExe pkgs.mesonlsp;
          };
          nu-lsp = {
            command = lib.getExe pkgs.nushell;
          };
          systemd-lsp = {
            command = lib.getExe pkgs.systemd-lsp;
          };
          jdtls = {
            command = lib.getExe pkgs.jdt-language-server;
          };
          kotlin-language-server = {
            command = lib.getExe pkgs.kotlin-language-server;
          };
          nil = {
            command = lib.getExe pkgs.nil;
          };
          awk-language-server = {
            command = lib.getExe pkgs.awk-language-server;
          };
          neocmakelsp = {
            command = lib.getExe pkgs.neocmakelsp;
          };
          cmake-language-server = {
            command = lib.getExe pkgs.cmake-language-server;
          };
          dts-lsp = {
            command = lib.getExe pkgs.dts-lsp;
          };
          glsl_analyzer = {
            command = lib.getExe pkgs.glsl_analyzer;
          };
          superhtml = {
            command = lib.getExe pkgs.superhtml;
          };
          jq-lsp = {
            command = lib.getExe pkgs.jq-lsp;
          };
          lua-language-server = {
            command = lib.getExe pkgs.lua-language-server;
          };
          marksman = {
            command = lib.getExe pkgs.marksman;
          };
          markdown-oxide = {
            command = lib.getExe pkgs.markdown-oxide;
          };
          openscad-lsp = {
            command = lib.getExe pkgs.openscad-lsp;
          };
          ruby-lsp = {
            command = lib.getExe pkgs.ruby-lsp;
          };
          solargraph = {
            command = lib.getExe pkgs.rubyPackages.solargraph;
          };
          taplo = {
            command = lib.getExe pkgs.taplo;
          };
          tombi = {
            command = lib.getExe pkgs.tombi;
          };
          tinymist = {
            command = lib.getExe pkgs.tinymist;
          };
        };
      };
    };
  };
}

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libsForQt5.kate
    nil
    nixd
    nodePackages_latest.bash-language-server
    nodePackages_latest.vscode-html-languageserver-bin
    nodePackages_latest.vscode-json-languageserver
    python311Packages.python-lsp-server
  ];
}


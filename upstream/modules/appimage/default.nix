{ config, lib, ... }:

let cfg = config.programs.appimage;
in {
  options.programs.appimage = {
    enable = lib.mkEnableOption "Enable AppImage Support";
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}

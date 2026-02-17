{
  config,
  lib,
  ...
}:

let
  cfg = config.jopejoe1.sway;
in
{
  options.jopejoe1.sway = {
    enable = lib.mkEnableOption "Enable Sway";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        output = {
          # Main Desktop
          "Acer Technologies Acer AL1717 0x70201097" = {
            mode = "1280x1024@75.025Hz";
            pos = "2560 0";
          };
          "LG Electronics LG ULTRAGEAR+ 305NTLE00976" = {
            mode = "2560x1440@143.991Hz";
            adaptive_sync = "on";
            pos = "0 0";
          };
          "Eizo Nanao Corporation EV2316W 36270122" = {
            mode = "1920x1080@60.000Hz";
            transform = "270";
            pos = "-1080 0";
          };
          # FrameWork 16
          "BOE 0x0BC9 Unknown" = {
            mode = "2560x1600@165.000Hz";
            pos = "0 0";
          };
          # Msi Laptop
          "LG Display 0x0259 Unknown" = {
            mode = "1920x1080@59.934Hz";
            pos = "0 0";
          };
        };
        input = {
          "12972:18:Framework_Laptop_16_Keyboard_Module_-_ANSI_Keyboard" = {
            "xkb_layout" = "us";
            "xkb_variant" = "altgr-intl";
            "xkb_model" = "pc104";
          };
          "5426:515:Razer_Razer_BlackWidow_Chroma" = {
            "xkb_layout" = "de";
            "xkb_model" = "pc105";
          };
          "1:1:AT_Translated_Set_2_keyboard" = {
            "xkb_layout" = "de";
            "xkb_model" = "pc105";
          };
        };
      };
    };
  };
}

{pkgs, inputs, ...}:

{
  stylix = {
    image = "${pkgs.libsForQt5.breeze-qt5}/share/wallpapers/Next/contents/images_dark/5120x2880.png";
    polarity = "dark";
    base16Scheme = "${inputs.catppuccin-base16}/base16/frappe.yaml";
  };
}

{pkgs, self, ...}:

{
  stylix = {
    image = "${pkgs.libsForQt5.breeze-qt5}/share/wallpapers/Next/contents/images_dark/5120x2880.png";
    polarity = "dark";
    base16Scheme = "${self.inputs.catppuccin-base16}/base16/frappe.yaml";
    fonts.emoji.package = pkgs.noto-fonts-color-emoji;
    fonts.emoji.name = "Noto Color Emoji";
  };
}

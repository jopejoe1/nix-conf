{ pkgs, ... }:

{
  imports =  [
    ./hardware-configuration.nix
  ];

  jopejoe1 = {
    audio = {
      enable = true;
    };
    bluetooth.enable = true;
    local.enable = true;
    jopejoe1.enable = true;
    nix.enable = true;
    root.enable = true;
  };

  networking.hostName = "tuny";
  boot.loader.grub.device = "/dev/sda";

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
  };

  users.users.musicp = {
    isNormalUser = true;
    description = "Music Player";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  environment.systemPackages = with pkgs; [
    mixxx
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

   # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "musicp";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}

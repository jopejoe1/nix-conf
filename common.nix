{ config, pkgs, lib, ... }:

{
  # Configure networking
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = lib.mkForce "kde";
  };

  virtualisation.waydroid.enable = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://prismlauncher.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
    ];
    trusted-users = [ "root" ];
    sandbox = true;
    require-sigs = true;
    max-jobs = "auto";
    auto-optimise-store = true;
    allowed-users = [ "*" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Enable services
  services = {
    # Configure X11
    xserver = {
      enable = true;
      displayManager = {
        sddm = {
          enable = true;
          enableHidpi = true;
        };
        lightdm.extraConfig = "user-authority-in-system-dir = true";
      };
      desktopManager = {
        plasma5 = {
          enable = true;
          supportDDC = true;
          useQtScaling = true;
        };
      };
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      webInterface = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };

    # Enable Network Printing and Scanning
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    # Enable pipewire
    pipewire = {
      enable = true;
      media-session.enable = false;
      wireplumber.enable = true;
      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };

  # Hardware configure
  hardware = {
    # Enable Scanning
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan pkgs.hplipWithPlugin ];
    };

    # Disable pulseaudio
    pulseaudio.enable = false;
  };

  # Enable ALSA
  sound.enable = false;

  # Configure Users
  users.users.jopejoe1 = {
    isNormalUser = true;
    description = "jopejoe1 🚫";
    initialPassword = "password";
    extraGroups = [ "wheel" "networkmanger" "scanner" "lp"];
    packages = with pkgs; [
      kate
      tela-icon-theme
      carla
      xdg-ninja
      prismlauncher
      nixpkgs-review
      nurl
      nix-init
    ];
  };

  environment.systemPackages = with pkgs; [
    partition-manager
    gparted
  ];

  programs = {
    dconf.enable = true;
  };

  security.rtkit.enable = true;

  # Localization
  i18n = {
    defaultLocale = "en_NZ.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
      LC_CTYPE = "de_DE.UTF-8";
      LC_COLLATE = "de_DE.UTF-8";
      LC_MESSAGES = "en_NZ.UTF-8";
    };
  };

  fonts.fontDir.enable = true;

  console = {
    enable = true;
    font = "Lat2-Terminus16";
  };

  xdg = {
    sounds.enable = true;
    mime.enable = true;
    menus.enable = true;
    icons.enable = true;
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal xdg-desktop-portal-gtk ];
    };
  };

  # Do not change unless made sure evrything works with new version
  system.stateVersion = "23.05";
}

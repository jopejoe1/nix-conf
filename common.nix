{ nixpkgs, ... }:

{

  services = {
    xserver = {
      enable = true;

      libinput.enable = true;

      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
      };
      desktopManager.plasma5 = {
        enable = true;
        useQtScaling = true;
      };
    };

    openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      allowSFTP = true;
      settings = {
        X11forwarding = true;
        PermitRootLogin = "no";
        passwordAuthentication = true;
        kbdInteractiveAuthentication = true;
      };
    };
  };

  programs.kdeconnect = {
    enable = true;
    package = pkgs.plasma5Packages.kdeconnect-kde;
  };

  xdg = {
    sounds.enable = true;
    mime.enable = true;
    menus.enable = true;
    icons.enable = true;
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal ];
    };
  };

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

  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.variables = {
    # Enable icons in tooling since we have nerdfonts.
    LOG_ICONS = "true";
  };

  fonts.fontDir.enable = true;

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://prismlauncher.cachix.org"
        "https://nixos-search.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
        "nixos-search.cachix.org-1:1HV3YF8az4fywnH+pAd+CXFEdpTXtv9WpoivPi+H70o="
      ];
      trusted-users = [ "root" ];
      sandbox = true;
      require-sigs = true;
      max-jobs = "auto";
      auto-optimise-store = true;
      allowed-users = [ "*" ];
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    # flake-utils-plus
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  security.rtkit.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;
  };

  hardware.pulseaudio.enable = mkForce false;

  environment.systemPackages = with pkgs; [
    sshfs
    deploy-rs
    nixfmt
    nix-index
    nix-prefetch-git
    nixpkgs-review
    nurl
    nix-init
  ];

  services.hardware.openrgb.enable = true;

  services.printing = {
    enable = true;
    webInterface = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = with pkgs; [ sane-airscan hplipWithPlugin ];
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  users.users.jopejoe1 = {
    isNormalUser = true;
    description = "jopejoe1 🚫";
    initialPassword = "password";
    packages = with pkgs; [
      git
      kate
      libsForQt5.ark
      libreoffice-qt
      texlive.combined.scheme-full
      tela-icon-theme
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCUWMJyy2qq2aacVv/J5raugh7UKEmCs+JpagQh30mYqwLV9YQtOfZ+A3Q1qOOLPHTTciLydsfz8K2jBGXEv49uqz9P33aw63RzSaLdcnXhBJRmZvJ3AujLBKDIo24PLOVasogtu01eyQALTg4npX+qlti2UsxLY5O8E5paFJvJ+5rGE3/34c4xA9xthUm7G7SCSt4AhVXwPGB1tqz1KLqGdTJQhvy80laEDSV4tAYpiabmjhNFKGpf8T7afnw1MzKXz+ba6exBcGaJfy2Q24DLztZsW7fsTE1iCdkbcmos9/jUR6NooKFgDr0M4CL2TVZB5pECSiOev06GMnLt+vpxjFL29YeGMaVMmNCedkL1z1mftbXLEL7934kEK9FpEpSwzbRTJ7iPvfYZuTHiT6fi2Ep7n+zzRS+/ZgDUDLSqZYEBmE4dO4LgcqzOsJo5EgoyLGoqQ4OpvPRY12T3rCWUfEgOCXgToF0WlUyxCaPZCfvUjM4LXNlIy/dtivMxMs8= jopejoe1@yokai"
    ];
  };
}


{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.jopejoe1.nix;
  # Based on https://github.com/nix-community/srvos/blob/30e6b4c2e5e7b235c7d0a266994a0c93e86bcf69/nixos/common/serial.nix#L8-L30
  # Based on https://unix.stackexchange.com/questions/16578/resizable-serial-console-window
  resize = pkgs.writeShellScriptBin "resize" ''
    export PATH=${pkgs.coreutils}/bin
    if [ ! -t 0 ]; then
      # not a interactive...
      exit 0
    fi
    TTY="$(tty)"
    if [[ "$TTY" != /dev/ttyS* ]] && [[ "$TTY" != /dev/ttyAMA* ]] && [[ "$TTY" != /dev/ttySIF* ]]; then
      # probably not a known serial console, we could make this check more
      # precise by using `setserial` but this would require some additional
      # dependency
      exit 0
    fi
    old=$(stty -g)
    stty raw -echo min 0 time 5

    printf '\0337\033[r\033[999;999H\033[6n\0338' > /dev/tty
    IFS='[;R' read -r _ rows cols _ < /dev/tty

    stty "$old"
    stty cols "$cols" rows "$rows"
  '';
in
{
  options.jopejoe1.nix = {
    enable = lib.mkEnableOption "Enable Nix";
  };
  options.jopejoe1.gui = {
    enable = lib.mkEnableOption "Enable GUI";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        substituters = lib.mkForce [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = lib.mkForce [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        sandbox = true;
        require-sigs = true;
        max-jobs = "auto";
        allowed-users = [ "*" ];
        trusted-users = [
          "builder"
          "jopejeo1"
          "root"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
          "cgroups"
          "fetch-closure"
          "no-url-literals"
        ];
        auto-allocate-uids = true;
        use-cgroups = true;
        warn-dirty = true;
        use-xdg-base-directories = true;
        keep-going = true;
        builders-use-substitutes = true;
        download-attempts = 1;
        fallback = true;
        allowed-uris = [
          "github:"
          "gitlab:"
        ];
      };
      buildMachines =
        let
          getMainArch =
            name:
            self.nixosConfigurations.${name}.config.nixpkgs.hostPlatform.system
              or self.nixosConfigurations.${name}.config.nixpkgs.system;
          getArchs =
            name:
            [ (getMainArch name) ]
            ++ self.nixosConfigurations.${name}.config.nix.settings.extra-platforms or [ ];
        in
        lib.filter (builder: builder.hostName != config.networking.hostName) [
          {
            systems = getArchs "hetzner";
            supportedFeatures = self.nixosConfigurations.hetzner.config.nix.settings.system-features;
            hostName = "hetzner";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxPNndNaFU1dndSdFV6ZytPVjJjdHF1K3FvaGVpQnlTbkp5alUwT1kwN0wgcm9vdEBoZXR6bmVyCg==";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            speedFactor = 5;
            maxJobs = (lib.elemAt self.nixosConfigurations.hetzner.config.facter.report.hardware.cpu 0).cores;
          }
          {
            systems = getArchs "zap";
            supportedFeatures = self.nixosConfigurations.zap.config.nix.settings.system-features;
            hostName = "zap";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU5Xb056T0QrM0UzT20xbGpkRUNxWUhaQkZteHA3bTNsS1MxSHBkQnZkZjYgcm9vdEB6YXAK";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            maxJobs = (lib.elemAt self.nixosConfigurations.zap.config.facter.report.hardware.cpu 0).cores;
          }
          {
            systems = getArchs "kuraokami";
            supportedFeatures = self.nixosConfigurations.kuraokami.config.nix.settings.system-features;
            hostName = "kuraokami";
            publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtJbFZhWTZ0aTJkVFVGUks0eFVoRitxa1kwbUhiT3pNSWpjTjZpMFNiTW0gcm9vdEBrdXJhb2thbWkK";
            sshUser = "builder";
            sshKey = "/root/.ssh/builder";
            speedFactor = 10;
            maxJobs = (lib.elemAt self.nixosConfigurations.kuraokami.config.facter.report.hardware.cpu 0).cores;
          }
        ];
      distributedBuilds = true;
      package = pkgs.lixPackageSets.git.lix;
      registry = lib.mkForce (
        (lib.mapAttrs (_: flake: { inherit flake; })) (
          (lib.filterAttrs (_: lib.isType "flake")) self.inputs
        )
        // {
          self.flake = self;
        }
      );
      nixPath = lib.mkForce [ "/etc/nix/path" ];

    };
    niri-flake.cache.enable = false;
    nixpkgs = {
      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        allowAliases = false;
      };
      overlays = [
        (_self: super: rec {
          firefox-addons = self.inputs.firefox-addons.packages.${config.nixpkgs.hostPlatform.system};
          localPkgs = self.outputs.packages.${config.nixpkgs.hostPlatform.system};
        })
      ];
    };

    environment.etc = lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    }) config.nix.registry;

    environment.systemPackages = with pkgs; [
      nix-index
      nix-prefetch-git
      nixpkgs-review
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [
        self.outputs.homeManagerModules.default
      ];
    };

    environment.loginShellInit = lib.getExe resize;

    system.etc.overlay = {
      mutable = false;
      enable = true;
    };

    security.sudo.execWheelOnly = true;

    system.preSwitchChecks.update-diff = lib.mkForce ''
      incoming="''${1-}"
      if [[ -e /run/current-system && -e "''${incoming-}" ]]; then
        echo "--- diff to current-system"
        ${lib.getExe pkgs.nvd} --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "''${incoming-}"
        echo "---"
      fi
    '';

    services.userborn.enable = true;

    sops.defaultSopsFile = ../../secrets/main.yaml;

    systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576000;
    systemd.services."serial-getty@".environment.TERM = "xterm-256color";

    boot.kernelParams = map (c: "console=${c}") (
      [
        "ttyS0,115200"
      ]
      ++ (lib.optional (pkgs.stdenv.hostPlatform.isAarch) "ttyAMA0,115200")
      ++ (lib.optional (pkgs.stdenv.hostPlatform.isRiscV64) "ttySIF0,115200")
      ++ [ "tty0" ]
    );

    networking.hosts = {
      "192.168.194.46" = [ "zap" ];
      "192.168.194.54" = [ "kuraokami" ];
      "192.168.194.208" = [ "hetzner" ];
      "192.168.194.232" = [ "omoikane" ];
    };
    users.mutableUsers = false;
    networking.useNetworkd = true;
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.network.wait-online.enable = false;
    systemd.services.systemd-networkd.stopIfChanged = false;
    systemd.services.systemd-resolved.stopIfChanged = false;
    boot.tmp.cleanOnBoot = true;
    programs.ssh.knownHosts = {
      "github.com".hostNames = [ "github.com" ];
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

      "gitlab.com".hostNames = [ "gitlab.com" ];
      "gitlab.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";

      "git.sr.ht".hostNames = [ "git.sr.ht" ];
      "git.sr.ht".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZvRd4EtM7R+IHVMWmDkVU3VLQTSwQDSAvW0t2Tkj60";
    };
  };
}

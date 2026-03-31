{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.jopejoe1.common.enable = (lib.mkEnableOption "common modules used by all systems") // {
    default = true;
  };

  options.jopejoe1.gui = {
    enable = lib.mkEnableOption "Enable GUI";
  };

  config = lib.mkIf config.jopejoe1.common.enable {
    system.etc.overlay = {
      mutable = true; # TODO set to false avahi currently need this
      enable = true;
    };

    boot.initrd.systemd.enable = true;

    security.sudo.execWheelOnly = true;

    environment.loginShellInit = lib.getExe pkgs.jopejoe1.resize;

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
    networking.wireless.userControlled = true;
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

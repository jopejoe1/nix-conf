# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

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

    security.run0 = {
      enable = true;
      sudo-shim.enable = true;
      persistentAuth.enable = true;
    };

    security.polkit.settings.Polkitd.ExpirationSeconds = 60;

    security.sudo.enable = false;

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
    programs.niri = {
      enable = config.jopejoe1.gui.enable;
      package =
        (pkgs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;
          settings = {
            xwayland-satellite = {
              path = lib.getExe pkgs.xwayland-satellite;
            };
            prefer-no-csd = true;
            window-rules = [
              {
                matches = [
                  {
                    app-id = "org.gnome.Nautilus";
                  }
                ];
                default-column-width.fixed = 360;
                open-focused = true;
              }
            ];
            binds = {
              "Super+D".spawn = [ "fuzzel" ];
              "Super+Shift+E".quit = null;
              "Super+Q".close-window = null;
              "Super+T".spawn = [ "alacritty" ];
              "Alt+L".spawn = [ "swaylock" ];
              "Super+Equal".set-column-width = "+10%";
              "Super+Minus".set-column-width = "-10%";
              "Super+F".maximize-column = null;
              "Super+H".focus-column-left = null;
              "Super+L".focus-column-right = null;
              "Super+K".focus-window-up = null;
              "Super+J".focus-window-down = null;
              "Super+I".focus-workspace-up = null;
              "Super+U".focus-workspace-down = null;
              "Super+Shift+H".focus-monitor-left = null;
              "Super+Shift+L".focus-monitor-right = null;
              "Super+Shift+K".focus-monitor-up = null;
              "Super+Shift+J".focus-monitor-down = null;
              "Super+Shift+I".move-workspace-up = null;
              "Super+Shift+U".move-workspace-down = null;
              "Super+Alt+H".move-column-left = null;
              "Super+Alt+L".move-column-right = null;
              "Super+Alt+K".move-window-up = null;
              "Super+Alt+J".move-window-down = null;
              "Super+Alt+I".move-column-to-workspace-up = null;
              "Super+Alt+U".move-column-to-workspace-down = null;
              "Super+Alt+Shift+H".move-column-to-monitor-left = null;
              "Super+Alt+Shift+L".move-column-to-monitor-right = null;
              "Super+Alt+Shift+K".move-column-to-monitor-up = null;
              "Super+Alt+Shift+J".move-column-to-monitor-down = null;
            };
            input.keyboard.xkb = {
              inherit (config.services.xserver.xkb)
                variant
                options
                model
                layout
                ;
            };
          };
        }).wrapper;
    };
  };
}

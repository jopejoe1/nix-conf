{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.repo-sync;
in {
  options.jopejoe1.repo-sync = {
    enable = lib.mkEnableOption "Enable Repo Sync";
  };

  config = lib.mkIf cfg.enable {
    systemd.timers."repo-sync" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "15m";
        Unit = "repo-sync.service";
      };
    };

    systemd.services."repo-sync" = {
      script = ''
        ${
          lib.getExe pkgs.git
        } clone git@codeberg.org:jopejoe1/nix-conf.git /var/lib/repo-sync
        ${
          lib.getExe pkgs.git
        } -C /var/lib/repo-sync remote add github git@github.com:jopejoe1/nix-conf.git
        ${
          lib.getExe pkgs.git
        } -C /var/lib/repo-sync remote add gitlab git@gitlab.com:jopejoe1/nix-conf.git
        ${lib.getExe pkgs.git} -C /var/lib/repo-sync pull -r github main
        ${lib.getExe pkgs.git} -C /var/lib/repo-sync pull -r gitlab main
        ${lib.getExe pkgs.nix} flake update /var/lib/repo-sync
        ${
          lib.getExe pkgs.git
        } -C /var/lib/repo-sync commit -m "flack.lock updated on `$(${pkgs.coreutils}/bin/date)`"
        ${lib.getExe pkgs.git} -C /var/lib/repo-sync push origin
        ${lib.getExe pkgs.git} -C /var/lib/repo-sync push github
        ${lib.getExe pkgs.git} -C /var/lib/repo-sync push gitlab
        ${pkgs.coreutils}/bin/rm -r /var/lib/repo-sync
      '';
      path = [ pkgs.openssh ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}


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
        git clone git@codeberg.org:jopejoe1/nix-conf.git /var/lib/repo-sync
        git -C /var/lib/repo-sync remote add github git@github.com:jopejoe1/nix-conf.git
        git -C /var/lib/repo-sync remote add gitlab git@gitlab.com:jopejoe1/nix-conf.git
        git -C /var/lib/repo-sync pull -r github main
        git -C /var/lib/repo-sync pull -r gitlab main
        nix flake update /var/lib/repo-sync
        git -C /var/lib/repo-sync commit -m "flack.lock updated on `$(date)`"
        git -C /var/lib/repo-sync push origin
        git -C /var/lib/repo-sync push github
        git -C /var/lib/repo-sync push gitlab
        rm -r /var/lib/repo-sync
      '';
      path = [ pkgs.openssh pkgs.git pkgs.coreutils pkgs.nix ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}


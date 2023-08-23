{ pkgs, ... }:

{
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
      ${pkgs.git}/bin/git -r -C /var/lib/repo-sync pull codeberg
      ${pkgs.git}/bin/git -r -C /var/lib/repo-sync pull github
      ${pkgs.git}/bin/git -r -C /var/lib/repo-sync pull gitlab
      ${pkgs.git}/bin/git -C /var/lib/repo-sync push origin
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}s

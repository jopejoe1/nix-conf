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
      ${pkgs.git}/bin/git -C /var/lib/repo-sync pull -r codeberg/main
      ${pkgs.git}/bin/git -C /var/lib/repo-sync pull -r github/main
      ${pkgs.git}/bin/git -C /var/lib/repo-sync pull -r gitlab/main
      ${pkgs.git}/bin/git -C /var/lib/repo-sync push origin
    '';
    path = [pkgs.openssh];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}

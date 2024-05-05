{pkgs, config, lib, ...}:

{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "wp.missing.ninja" = {
        serverName = "wp.missing.ninja";
        root = "/var/www/wordpress/";
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          index index.php;
        '';
        locations = {
          "/" = {
            priority = 200;
            extraConfig = ''
              try_files $uri $uri/ /index.php$is_args$args;
            '';
          };
          "~ \\.php$" = {
            priority = 500;
            extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.wordpress.socket};
              fastcgi_index index.php;
              include "${config.services.nginx.package}/conf/fastcgi.conf";
              fastcgi_param PATH_INFO $fastcgi_path_info;
              fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
              # Mitigate https://httpoxy.org/ vulnerabilities
              fastcgi_param HTTP_PROXY "";
              fastcgi_intercept_errors off;
              fastcgi_buffer_size 16k;
              fastcgi_buffers 4 16k;
              fastcgi_connect_timeout 300;
              fastcgi_send_timeout 300;
              fastcgi_read_timeout 300;
            '';
          };
          "~ /\\." = {
            priority = 800;
            extraConfig = "deny all;";
          };
          "~* /(?:uploads|files)/.*\\.php$" = {
            priority = 900;
            extraConfig = "deny all;";
          };
          "~* \\.(js|css|png|jpg|jpeg|gif|ico)$" = {
            priority = 1000;
            extraConfig = ''
              expires max;
              log_not_found off;
            '';
          };
        };
      };
    };
  };

  users.users.www-wordpress= {
    isNormalUser = true;
    group = "www-wordpress";
    packages = with pkgs; [
      git # maybe you want or need this
      php82 # specify whatever version you want
      php82.packages.composer
    ];
  };

  users.groups.www-wordpress = { };

  services.phpfpm.pools.wordpress = {
    phpPackage = pkgs.php82;
    user = "www-wordpress";
    group = "www-wordpress";
    settings = {
      "listen.owner" = config.services.nginx.user; # or nginx, httpd, etc...
      "listen.group" = config.services.nginx.group;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 4;
      "pm.max_requests" = 500;
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    #ensureDatabases = [ "www-wordpress" ];
    #ensureUsers = [
    #  {
    #    name = "www-wordpress";
    #    ensurePermissions = { "www-wordpress.*" = "ALL PRIVILEGES"; };
    #  }
    #];
   };

   systemd.services =
   let
    secretsVars = [ "AUTH_KEY" "SECURE_AUTH_KEY" "LOGGED_IN_KEY" "NONCE_KEY" "AUTH_SALT" "SECURE_AUTH_SALT" "LOGGED_IN_SALT" "NONCE_SALT" ];
    secretsScript = hostStateDir: ''
      # The match in this line is not a typo, see https://github.com/NixOS/nixpkgs/pull/124839
      grep -q "LOOGGED_IN_KEY" "${hostStateDir}/secret-keys.php" && rm "${hostStateDir}/secret-keys.php"
      if ! test -e "${hostStateDir}/secret-keys.php"; then
        umask 0177
        echo "<?php" >> "${hostStateDir}/secret-keys.php"
        ${lib.concatMapStringsSep "\n" (var: ''
          echo "define('${var}', '`tr -dc a-zA-Z0-9 </dev/urandom | head -c 64`');" >> "${hostStateDir}/secret-keys.php"
        '') secretsVars}
        echo "?>" >> "${hostStateDir}/secret-keys.php"
        chmod 440 "${hostStateDir}/secret-keys.php"
      fi
    '';
   in
   {
    "wordpress-init" = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-wordpress.service" ];
      after = [ "mysql.service" ];
      script = secretsScript "/var/www/wordpress/";

      serviceConfig = {
        Type = "oneshot";
        User = "www-wordpress";
        Group = "nginx";
      };
    };
  };
}

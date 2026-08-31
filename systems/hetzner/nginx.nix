# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    commonHttpConfig = "access_log syslog:server=unix:/dev/log;";
    virtualHosts = {
      "missing.ninja" = {
        serverAliases = [
          "joens.zone"
          "joens.website"
          "joens.site"
          "joens.online"
          "joens.link"
          "joens.international"
          "joens.family"
          "joens.digital"
          "joens.blog"
          "net0loggy.net"
          "clan-war.net"
          "net0loggy.de"
          "dtg-c.de"
        ];
        enableACME = true;
        acmeRoot = null;
        forceSSL = true;
      };
      "webmail.missing.ninja" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        serverAliases = [ "joens.email" ];
      };
      "pad.missing.ninja" = {
        forceSSL = true;
        acmeRoot = null;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:3333";
        locations."/socket.io/" = {
          proxyPass = "http://localhost:3333";
          proxyWebsockets = true;
          extraConfig = "proxy_ssl_server_name on;";
        };
      };
      "test.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
      };
      "search.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/".proxyPass = "http://localhost:8080";
      };
      "hydra.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/".proxyPass = "http://localhost:3000";
      };
      "ci.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/".proxyPass = "http://localhost:8000";
      };
      "cache.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/".proxyPass =
          "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
      "mta-sts.missing.ninja" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        serverAliases = lib.map (x: "mta-sts.${x}") config.mailserver.domains; 
        locations."/" = {
          root = pkgs.writeTextDir ".well-known/mta-sts.txt" ''
            version: STSv1
            mode: enforce
            mx: mail.missing.ninja
            max_age: 86400
          '';
        };
      };
      "hetzner" = {
        forceSSL = false;
        enableACME = false;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:1242";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $host:$server_port;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Server $host;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Upgrade $http_upgrade;
            '';
          };
          "/Api/NLog" = {
            proxyPass = "http://127.0.0.1:1242";
            extraConfig = ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $host:$server_port;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Server $host;
            '';
          };
        };
      };
    };
  };

  networking.domains = {
    enable = true;
    baseDomains = lib.listToAttrs (
      lib.map (x: {
        name = x;
        value = { };
      }) config.mailserver.domains
    );
    subDomains =
      lib.recursiveUpdate
        (lib.recursiveUpdate
          (lib.listToAttrs (
            lib.concatMap (x: [
              {
                name = x;
                value = {
                  caa.data = {
                    flags = 0;
                    tag = "issue";
                    value = "letsencrypt.org";
                  };
                  txt.data = "v=spf1 a:mail.missing.ninja -all";
                  mx.data = {
                    exchange = "mail.missing.ninja";
                    preference = 10;
                  };
                  ns.data = [
                    "ns1.desec.io"
                    "ns2.desec.org"
                  ];
                };
              }
              {
                name = "_mta-sts.${x}";
                value.txt.data = "v=STSv1; id=1;";
              }
              {
                name = "_dmarc.${x}";
                value.txt.data = "v=DMARC1; p=quarantine; sp=quarantine; pct=100; fo=0:1:d:s; aspf=s; adkim=s; rf=afrf; rua=mailto:report@missing.ninja; ruf=mailto:report@missing.ninja;";
              }
              {
                name = "_imaps._tcp.${x}";
                value.srv.data = {
                  priority = 6;
                  weight = 0;
                  port = 993;
                  target = "mail.missing.ninja";
                };
              }
              {
                name = "_imap._tcp.${x}";
                value.srv.data = {
                  priority = 6;
                  weight = 0;
                  port = 143;
                  target = "mail.missing.ninja";
                };
              }
              {
                name = "_submissions._tcp.${x}";
                value.srv.data = {
                  priority = 5;
                  weight = 0;
                  port = 465;
                  target = "mail.missing.ninja";
                };
              }
              {
                name = "_submission._tcp.${x}";
                value.srv.data = {
                  priority = 5;
                  weight = 0;
                  port = 587;
                  target = "mail.missing.ninja";
                };
              }
            ]) config.mailserver.domains
          ))
          (
            lib.concatMapAttrs (
              name: val:
              {
                ${name} = {
                  a.data = "85.10.200.204";
                  aaaa.data = "2a01:4f8:a0:31e5::";
                };
              }
              // lib.listToAttrs (
                lib.map (x: {
                  name = x;
                  value = {
                    a.data = "85.10.200.204";
                    aaaa.data = "2a01:4f8:a0:31e5::";
                  };
                }) val.extraDomainNames
              )
            ) config.security.acme.certs
          )
        )
        {
          "_465._tcp.mail.missing.ninja".tlsa.data = {
            usage = 3;
            selector = 1;
            matchingType = 1;
            certificateAssociationData = "ced4ecc30ffa1f5d2a6d486a55f0b58dae6f12500722406d671c5066063cc5cf";
          };
          "_587._tcp.mail.missing.ninja".tlsa.data = {
            usage = 3;
            selector = 1;
            matchingType = 1;
            certificateAssociationData = "ced4ecc30ffa1f5d2a6d486a55f0b58dae6f12500722406d671c5066063cc5cf";
          };
          "_25._tcp.mail.missing.ninja".tlsa.data = {
            usage = 3;
            selector = 1;
            matchingType = 1;
            certificateAssociationData = "ced4ecc30ffa1f5d2a6d486a55f0b58dae6f12500722406d671c5066063cc5cf";
          };
          "mail._domainkey.missing.ninja".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyNxukDDKwufGDGOGOtuTcOvBqQ4AfwDIFCvxIxZUnJ0QkNUbJGc+pbLRMIqfafAaRjYnmSb2E7KpWOtvx3QLDu0pQuwS1CxzidSrVOBvQOPLHtNQR6O3Nqi6YSp/PIwLNZepqqR7ofaBdobu6M/vtAGfo3uBpw4c1VxyG/bftEQIDAQAB";
          "mail._domainkey.joens.zone".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCp2I6/Q4Jl7y1kAoqPsXroJsAaxYP2FM58UQH8anu7hFpa3wzAygvZPw/Sh+KqGEfZCLf+RLxUdKW9nTztV4msNgJy5gU0MfbEBls6wXGbI9ESRqFnWKtRvvbGx8VVZEXhDKBMDCMYVmMa6biNoAsH7+Qk2vGw60zVhkgHUk5evwIDAQAB";
          "mail._domainkey.joens.website".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDL7Se5FVOmM1I9LyB5HFCY0VohDkzuReZsN5ySPMZrGoYQKyc6LaaiIRvEUc9G5pO1+YheG6ksBPkG/bauNbZTI88KuwNRKcAFUqozDTOt74RG+UPhLHCMwhrCIU6LtkjjPn2T8Kxpa1iA7L4SRLYOwNOt9ZEx2zneTiNTG/gUwIDAQAB";
          "mail._domainkey.joens.site".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDXbV+xkKwcg6+5QHAesKIrtFNhgpMZeoALxsYk4PDTDAxiu4RDvKfHAf80jNvxBllCX9WqHy37Hz6qlKR2t35/qxnv88dMuqWTix4jv5TUkI/yupFBwFbl851ay7/YAIewJ0NPdbXVNHorfOgQttSIjRToqnLT76YxTJyZiMK7bwIDAQAB";
          "mail._domainkey.joens.online".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDMEjYLVvPIiWmR3zOBLrBe1lsZARmkq5uOQICmJx82ZjPcrxsQgklVytjpD5QSV4ikw8hmZxCX0egs7KalTR6DRUtrIUC39HoufgYiPc5+NmKPJdiccjVIN8Ir0uZ2rFYb2wGvc8L60CRRkETVqjriPRMMOhb+QiBWTnTV2cjYVwIDAQAB";
          "mail._domainkey.joens.link".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyBinClVNWm7icC9WqOBzWnFWaD/wUYwM1Y4GqGuA6aHqzsiFfUrVTAHfVDL6ocnINKnyidxrl1rGhu3T6e+0V1CuzMHQC8pbt2e1uEQZyf2cpIQhFVCIcjt7mjpyGwqgKI+ECEgc0cUeg6nRglm3oJOIwEmv8JuJ2U0ExWPA5DQIDAQAB";
          "mail._domainkey.joens.international".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDiPol6Y0IcXO680LIM4yY7fJxgVsTEDp5hHB1P7jJ0RGaKWtttQ40GaJtcm+8Ul26pT2AOtilN07yUv3EGsM+dtR/3s8idNwY0zISLN8HSvBYLnitEmjzjya3RGHftf9upVEA3IShyfpvXAd5mZXCjlZbQWFAuuQFJJtyU0RepuQIDAQAB";
          "mail._domainkey.joens.family".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDQymOu4GK/5/lRzfyeY12Er8hr6nd6ZuXKxnD85Cs9OGmmhA0gQwMzUU64Ej028jujDuE7K+DyetT+lzVncZI1W3drgz4Ga/0BxYZyYYUf8clDSVFXWfoajN6trGjQ/Bg19YJexwN4QZBXL5GQVeLiR7w4P9L1dYbpyITvJcmwzwIDAQAB";
          "mail._domainkey.joens.email".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBbpirCqNtgYhGTzrCnpg9yFL93SJrd5dIu3QKWAqZXcUg56YU1ThlukAYvhQ/Y8ry7Im8eelvQb620J9qRQp3y0vJzl7A8u9ci9K9unTdABJq56o5legPlUXl72xMfNTlrbXMjPJ/Sa2Bfxi+7Q5GGmOA2iFXWfA0QbXWp3SmawIDAQAB";
          "mail._domainkey.joens.digital".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvAkTjMdYuPdQbBiscGDMYaNwe1gtmNGOa6bmqcLP6c0yfjzmpNuBwGU3x880gv/i7OUx4jhELn/e13B9/D10ziKSPkWLkf646C458v+jjU/SeK7seihnQ9gGrzLU31BDqJGzo9AC4FG95sNtsht6g7AVYmxjOAFgEJn7kOIU5GQIDAQAB";
          "mail._domainkey.joens.blog".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCcfDsHBlHigZ5tXYOSelsmazJGdjg9/TWlcth3TicBd52UCFNMMzjDqTelmILEUuw+DV2ZV4iU5IMSze+uAQQLliSzAYsNtnStHaq+UePObpuT1dR38Dbq+AwWdFnxjKZCKcbrTkVjtacjYFtMwQxSP0OwrlTDRDVfPrZKbgQyFQIDAQAB";
          "mail._domainkey.net0loggy.net".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCoSbSPfv/Q4xz6teNjvfjSJEXT2ZnAmTA80OpZaCN1zynnQg9NtE0p85FuLA+a6QFDbdmcQzHsgOg74UbZZkFquCKc4ULfdypqgISe+XJSRyDUY4ekih0CWY85RKPjvb22o7YjRPB1aBJ9Mg+P4ijV8Z84Sb6Jfq9m6a2SLaL1LwIDAQAB";
          "mail._domainkey.clan-war.net".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC1B/cdvU8AY+dnDBzcWKkso8Yv0WAxMyP/yRsaFvS1kSTs8JxkF3cQwyYdkJnh0hy2bdoJTqkoGh5TtPeOcfyCzYrW0P+JtM770kZY8LPXFy3eee0HjrHkVgYTguQl4oChhtnUEJYQhb2rArw34qTlsrTLWo2fWDJwH80+e36lTQIDAQAB";
          "mail._domainkey.net0loggy.de".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGhMUnrH/ON+oBAQqTMshphRwnrOHCilfX37UygLP0zWabNIgEH9OZs92yskOi2SQ6xsBbXsAx99ksBolLv8nnuJThrCEZn/I1tODaDOp5/MFXLMwkIO6zueJY1W7sa1QDHBeKLm87Tn5FqMt/oLj6NbdMT0rlxyLnFmCfCx+gPwIDAQAB";
          "mail._domainkey.dtg-c.de".txt.data =
            "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDLTRAZg0zS3WHwmUtcK51MBEHlAhu7D3xlD8g5FBEqsrqoJ917ZMgKBOwbeBXzreIGYuALYEmmGpTJOqBNQa24PFliFd54I3QMIw+KnhqhBixEHwmijl6Uo9PZ5ENiNbS+X3FaW684NXZvi47nHGOvimoU4kUeXES8H4KWgLLvSwIDAQAB";
        };
  };

  services.hedgedoc = {
    enable = true;
    settings = {
      db = {
        dialect = "sqlite";
        torage = "/var/lib/hedgedoc/db.hedgedoc.sqlite";
      };
      domain = "pad.missing.ninja";
      port = 3333;
      useSSL = false;
      protocolUseSSL = true;
    };
  };
}

{ ... }:

{
  services.peertube = {
    enable = true;
    secrets.secretsFile = "/run/secrets/peertube";
    redis.createLocally = true;
    database.createLocally = true;
    localDomain = "peertube.local";
  };
}

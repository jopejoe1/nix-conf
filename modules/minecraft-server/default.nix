{ ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    serverProperties = {
      difficulty = 3;
      enable-rcon = true;
      "rcon.password" = "test";
      motd = "\\u00A7cWake up to reality! Nothing ever goes as planned in this accursed world.☯";
      spawn-protection = 0;
      level-type = "minecraft:amplified";
      level-name = "amplified_world";
    };
  };
}

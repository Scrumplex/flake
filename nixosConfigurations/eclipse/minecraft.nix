{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlays.default];

  nixpkgs.allowedUnfreePackageNames = ["minecraft-server"];

  infra.borg-rsync-net.extraExcludes = [
    "*/DistantHorizons.sqlite"
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.forever = let
      modpack = pkgs.fetchModrinthModpack {
        name = "adrenaline-26.5.1";
        url = "https://github.com/skywardmc/adrenaline/releases/download/26.5.1/Adrenaline-26.5.1+mc26.3.fabric.mrpack";
        packHash = "sha256-zpP38NZUUdmcITViXf+dvqEa1q9sh09Ot4eNQDDQ9tg=";
      };

      mods =
        inputs.nix-minecraft.lib.collectFilesAt modpack "mods"
        // {
          "mods/appleskin.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/PHjDtQay/appleskin-fabric-mc26.3-3.0.10.jar";
            hash = "sha256-ywUIfDnw2GBhGqH6589jVgIU0bcTeKfJA8GNw3C1w84=";
          };
          /*
            "mods/dcintegration-fabric-MC1.21.10-3.1.0.1.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/rbJ7eS5V/versions/DJOsldZY/dcintegration-fabric-MC1.21.10-3.1.0.1.jar";
            hash = "";
          };
          */
          "mods/DistantHorizons.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/TGgEbP9A/DistantHorizons-3.3.4-26.3-fabric-neoforge.jar";
            hash = "sha256-uj5chadloQkhmDHfmbme9c/N7gWy36Z5YRaZO9SNOUc=";
          };
          "mods/fastback.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ZHKrK8Rp/versions/RvW6Ltl7/fastback-fabric-0.35.0%2B26.3.0.jar";
            hash = "sha256-wsN2vWAeB0XFIqmvQOiBEnH3vlKXWp9l69sWC+zI7q0=";
          };
          "mods/Geyser.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/rUOASU7J/Geyser-Fabric-2.12.0-b1265.jar";
            hash = "sha256-WUqmSeYBMgUBN1NNIvpC7seSGel8RkY8k6ZOvR0EeRs=";
          };
          "mods/Jade.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/71CTWqdE/Jade-mc26.3-Fabric-26.3.5.jar";
            hash = "sha256-SJnWxgr6KvhZs6fggk0O9rQE8mRY+DHj2Hf6o2vprxw=";
          };
          "mods/journeymap.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/2zmj8ela/journeymap-fabric-26.3-6.0.10.jar";
            hash = "sha256-m8k5X0gdC8tl1prtI3SRIOfM0oeAW66Wvu+8Dv2v1Ww=";
          };
          "mods/mobexplosiongriefinggamerule.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l9H9JPmo/versions/jmz3ZO8r/mob_explosion_griefing-2.1.2%2B26.1-26.3.jar";
            hash = "sha256-KuM2DFIHV6Np1pc0sXksRnVhWjFSbIF3VEzHA/41Qxc=";
          };
          "mods/NoChatReports.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/6g96avt2/NoChatReports-FABRIC-26.3-v2.21.0.jar";
            hash = "sha256-00Y5G+p5kbpdXrPIMIpBS/xnNNbSIL7OhOdpZsg0tb8=";
          };
          "mods/return-my-gold-farm.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/kuRpWzg6/versions/AGwgY1Vh/return-my-gold-farm-fabric-mc26.1-2.1.1.jar";
            hash = "sha256-iXIqhPrM5+hHIOU0lgQWKjqKdF0esImHMRH3XTxWR2k=";
          };
          "mods/spark.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/e3hsPc1o/spark-1.10.187-fabric.jar";
            hash = "sha256-P8AGY8qlQrHngzNzBgm06yVoMmYo42ZqOTitWMvJrMY=";
          };
          "mods/worldedit.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/ByRNkO83/worldedit-mod-7.4.6.jar";
            hash = "sha256-JPIzisnV5yBfFc20oRiSTF2cvUirDKv4ujawe31kwis=";
          };
        };
    in {
      enable = true;
      package = pkgs.fabricServers.fabric-26_3.override (old: {
        jre_headless =
          lib.warnIf (
            lib.versions.major old.jre_headless.version == "25"
          ) "nix-minecraft is using Java 25, override is now redundant"
          pkgs.openjdk25_headless;
      });
      path = with pkgs; [git git-lfs];

      jvmOpts = concatStringsSep " " [
        "-Xmx8G"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+UseZGC"
        "-XX:+ZGenerational"
        "-XX:+AlwaysPreTouch"
        "-XX:+DisableExplicitGC"
        "-XX:+PerfDisableSharedMem"
        "-XX:+UseDynamicNumberOfGCThreads"
      ];

      whitelist = {
        "freckled_Star" = "8c7e6c67-9f59-4f79-afcf-bdff40df6db1";
        "Honey_Arcus" = "35ab6244-3e9e-452d-a6cd-258868d3cad7";
        "ItsJustStone" = "863ec9e8-09e0-4c33-a085-d34223206fa4";
        "NotGanondorf" = "557730db-9732-4727-99db-b46f8ad7535c";
        "Scrumplex" = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      operators = {
        "Scrumplex".uuid = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      symlinks = mods;

      files = inputs.nix-minecraft.lib.collectFilesAt modpack "config";

      serverProperties = {
        difficulty = "normal";
        enforce-secure-profile = false;
        motd = "scrumplex.net";
        spawn-protection = 0;
        white-list = true;
        allow-flight = true;
        level-seed = "7830518263619659759";
        server-port = 25566;
      };
    };
  };

  networking.firewall.allowedUDPPorts = [19132]; # Geyser

  # Some Minecraft servers leak a lot of memory.
  # We are talking about Minecraft modders here so there are infinite possibilities as to why this happens.
  # To stop the host from OOMing after some time, tell systemd to deal with this early on
  systemd.services = lib.mapAttrs' (name: _:
    lib.nameValuePair "minecraft-server-${name}" {
      serviceConfig.MemoryMax = "16G"; # kill the server if it sucks up too much
    }) (lib.filterAttrs (_: v: v.enable) config.services.minecraft-servers.servers);
}

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
      modpack = pkgs.fetchPackwizModpack {
        name = "adrenaline-26.1.2";
        url = "https://github.com/skywardmc/adrenaline/raw/d2b3c6524961c7ac4ea78ca032a2ce4058bdf3cc/versions/fabric/26.1.2/pack.toml";
        packHash = "sha256-MIHfggVkse4FpurNmlB4u2cG3Ya8H5YR+Gm9hmLzWvU=";
      };

      mods =
        inputs.nix-minecraft.lib.collectFilesAt modpack "mods"
        // {
          "mods/appleskin-fabric-mc26.1-3.0.9.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/HwaLJe3v/appleskin-fabric-mc26.1-3.0.9.jar";
            hash = "sha256-iNCycR/oxqFpbPGfIcfgfWOm7PzPiIu5AmBWb8asTb4=";
          };
          /*
            "mods/dcintegration-fabric-MC1.21.10-3.1.0.1.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/rbJ7eS5V/versions/DJOsldZY/dcintegration-fabric-MC1.21.10-3.1.0.1.jar";
            hash = "sha256-2toKtlufC/oW1iK4hhQMMdp1B9NY48jYaf1g0A3ir34=";
          };
          */
          "mods/DistantHorizons-3.0.3-b-26.1.2-fabric-neoforge.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/FJrLlu3p/DistantHorizons-3.0.3-b-26.1.2-fabric-neoforge.jar";
            hash = "sha256-bvQZMYQ/VCaIsU4L95JgWuK8F691zgFYYWEkfv/sMVU=";
          };
          "mods/fastback-fabric-0.33.0+26.1.2.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ZHKrK8Rp/versions/QIxDzHv6/fastback-fabric-0.33.0%2B26.1.2.jar";
            hash = "sha256-tkAaiB5V/4hKBRowS45KhnoRh399SJcg+QkFiPjXSpI=";
          };
          "mods/Geyser-Fabric-2.10.0-b1161.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/Zv3IaIl5/Geyser-Fabric-2.10.0-b1161.jar";
            hash = "sha256-Kc/B6pq42YBZgQBzoT8PhUvY3APzxaYW9MXZNYxTBbM=";
          };
          "mods/Jade-mc26.1-Fabric-26.1.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/QglgrEFX/Jade-mc26.1-Fabric-26.1.0.jar";
            hash = "sha256-ClGpoF6lPSL6M9uJt26s0nV451IUlJmu0ZdOdpJLMew=";
          };
          "mods/journeymap-fabric-26.1.2-6.0.0-beta.85.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/jP3MlN9K/journeymap-fabric-26.1.2-6.0.0-beta.85.jar";
            hash = "sha256-GJ5yoZID6XD7FleEBCLPAOurXmXcNsGYoB9kW7VkVTc=";
          };
          "mods/mob_explosion_griefing-2.1.0+26.1.x.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l9H9JPmo/versions/FgxgRIlb/mob_explosion_griefing-2.1.0%2B26.1.x.jar";
            hash = "sha256-wTxb3JP+ZvXSR4Tz6+0UGn2lL5XvZd4PMkb4S0+EfG4=";
          };
          "mods/NoChatReports-FABRIC-26.1-v2.19.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/2yrLNE3S/NoChatReports-FABRIC-26.1-v2.19.0.jar";
            hash = "sha256-sySe6xxj3VDAF6e14DnuhMn2hbfQ3a57PrRqhzWlN7Q=";
          };
          "mods/return-my-gold-farm-2.0.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/kuRpWzg6/versions/X5dHDFmD/return-my-gold-farm-2.0.0.jar";
            hash = "sha256-fzKQs5l9Xr5JRe63KZ7QYzRUgvPPCErqi6DWIbiPXTU=";
          };
          "mods/spark-1.10.172-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/J1GUYyGQ/spark-1.10.172-fabric.jar";
            hash = "sha256-m++Dstsza1EwD2nfcw7ejGTEEHp5aKDAGylNLu8HWQw=";
          };
          "mods/worldedit-mod-7.4.3.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/gjsLvJfW/worldedit-mod-7.4.3.jar";
            hash = "sha256-qLDZza+snnGN4NAMST1JxFNeQQCMUbhGnRbNeIZdifI=";
          };
        };
    in {
      enable = true;
      package = pkgs.fabricServers.fabric-26_1_2.override (old: {
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

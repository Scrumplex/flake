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

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.forever = let
      modpack = pkgs.fetchPackwizModpack {
        name = "adrenaline-1.21.11";
        url = "https://github.com/skywardmc/adrenaline/raw/a53b858ded8d454f5a640311e554d2239335b710/versions/fabric/1.21.11/pack.toml";
        packHash = "sha256-ACOabF0qkzWaW7KjFUdB4FJaoqqlbX+1x4uphZAkK1E=";
      };

      mods =
        inputs.nix-minecraft.lib.collectFilesAt modpack "mods"
        // {
          "mods/appleskin-fabric-mc1.21.11-3.0.7.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/pvcLnrm0/appleskin-fabric-mc1.21.11-3.0.7.jar";
            hash = "sha256-UOjD6vafWRmhbMQijPq9Xzudd0E9Jng0mSw+PFGuk+0=";
          };
          "mods/DistantHorizons-2.4.2-b-1.21.11-fabric-neoforge.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/MEUmB9jk/DistantHorizons-2.4.2-b-1.21.11-fabric-neoforge.jar";
            hash = "sha256-impqlgDtlf22xnOpC47yCGOXHykCzRZqFWG5ZI6IDAc=";
          };
          "mods/fastback-0.29.0+1.21.10-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ZHKrK8Rp/versions/DtjrGc8t/fastback-0.29.0%2B1.21.10-fabric.jar";
            hash = "sha256-I81490umifppBg65BB+TOsAljEz/z5ppaU8sM80/hoI=";
          };
          "mods/geyser-fabric-Geyser-Fabric-2.9.2-b1009.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/ddHFw0nu/geyser-fabric-Geyser-Fabric-2.9.2-b1009.jar";
            hash = "sha256-c5HRJCKiXZJDJId9wtnWlM+hkR61r2tRVVSek1a2YPE=";
          };
          "mods/Jade-1.21.11-Fabric-21.0.1.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/7cBo3s22/Jade-1.21.11-Fabric-21.0.1.jar";
            hash = "sha256-kHYGgsk9Kvfo4bIXA8R1GdVvTvdSorBRjSHTF5bqStM=";
          };
          "mods/NoChatReports-FABRIC-1.21.10-v2.16.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/78RjC1gi/NoChatReports-FABRIC-1.21.10-v2.16.0.jar";
            hash = "sha256-vTrtFM2n9ED2pAmIRGePhNv7aycwCmF1OIWATaerYuQ=";
          };
          "mods/return-my-gold-farm-2.0.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/kuRpWzg6/versions/X5dHDFmD/return-my-gold-farm-2.0.0.jar";
            hash = "sha256-fzKQs5l9Xr5JRe63KZ7QYzRUgvPPCErqi6DWIbiPXTU=";
          };
          "mods/spark-1.10.156-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/1CB3cS0m/spark-1.10.156-fabric.jar";
            hash = "sha256-Nu0Tj/3iovH8sy7LzH+iG+rxYR4APRnjrUCVSHPlcvo=";
          };
          "mods/worldedit-mod-7.3.18-beta-01.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/ZmRjhuVs/worldedit-mod-7.3.18-beta-01.jar";
            hash = "sha256-VuUFrKbl1P1StwB7kYCsag2dji82xS+X9OHU8lAOzC8=";
          };
          "mods/ViaFabric-0.4.21%2B129-main.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/YlKdE5VK/versions/jmsoyTm9/ViaFabric-0.4.21%2B129-main.jar";
            hash = "sha256-ODt665lecEM7Zwckxfn6mC9yg9To4/CWpKj6uPbqMw0=";
          };
        };
    in {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_11;
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
        "Scrumplex" = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      operators = {
        "Scrumplex".uuid = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      symlinks = mods;

      files = {
        "config" = "${modpack}/config";
      };

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

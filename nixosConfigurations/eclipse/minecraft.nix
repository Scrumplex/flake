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

    servers.hyperwoofer = {
      enable = true;
      package = pkgs.writeShellApplication {
        name = "minecraft-server";

        runtimeInputs = [pkgs.jdk21];

        text = ''
          exec java "$@" @libraries/net/neoforged/neoforge/21.1.215/unix_args.txt nogui
        '';
      };

      jvmOpts = concatStringsSep " " [
        "-Xmx12G"
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
      ];

      whitelist = {
        "Honey_Arcus" = "35ab6244-3e9e-452d-a6cd-258868d3cad7";
        "Scrumplex" = "f2873756-429d-413a-b22d-6a976ed0d3f2";
        "BronyCovfefe" = "4b366973-b903-4bf9-8de7-1a2ab8fe2b31";
        "TokiNoKotei" = "89b951e4-89d3-4881-a682-670a8a782a84";
        "Zeiver" = "53b7f056-a274-4b63-b5f1-64a5657113f5";
      };

      operators = {
        "Scrumplex".uuid = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      symlinks = {
        "mods/AdvancedBackups-neoforge-1.21-3.7.1.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/Jrmoreqs/versions/ufIaRDFo/AdvancedBackups-neoforge-1.21-3.7.1.jar";
          hash = "sha256-UKNpnwWVIDW7vStfPp4R/MQ7/J1f7owQS07Xsy70lr4=";
        };
        "mods/DistantHorizons-2.3.6-b-1.21.1-fabric-neoforge.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/uCdwusMi/versions/uzLZ00HG/DistantHorizons-2.3.6-b-1.21.1-fabric-neoforge.jar";
          hash = "sha256-VCEWJp12161VwVREmB3taKixhqLGd8VlZEaqWEIr7/s=";
        };
        "mods/spark-1.10.124-neoforge.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/l6YH9Als/versions/v5qtqRQi/spark-1.10.124-neoforge.jar";
          hash = "sha256-ZH6Kga++QU26HfS6Ff0GxdMtTLVE5ogoQF6OB0wuFts=";
        };
      };

      serverProperties = {
        difficulty = "normal";
        enforce-secure-profile = false;
        motd = "scrumplex.net";
        spawn-protection = 0;
        white-list = true;
        allow-flight = true;
      };
    };
  };

  # Some Minecraft servers leak a lot of memory.
  # We are talking about Minecraft modders here so there are infinite possibilities as to why this happens.
  # To stop the host from OOMing after some time, tell systemd to deal with this early on
  systemd.services = lib.mapAttrs' (name: _:
    lib.nameValuePair "minecraft-server-${name}" {
      serviceConfig.MemoryMax = "16G"; # kill the server if it sucks up too much
    }) (lib.filterAttrs (_: v: v.enable) config.services.minecraft-servers.servers);
}

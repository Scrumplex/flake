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

    servers.forever = let
      modpack = pkgs.fetchPackwizModpack {
        name = "adrenaline-1.21.10";
        url = "https://github.com/skywardmc/adrenaline/raw/566083a964d3a43951693001a26bedba673cd674/versions/fabric/1.21.10/pack.toml";
        packHash = "sha256-FCXRxrJs4WzS9LY6HP2Taw176ataGD8YinBFag7Y9ys=";
      };

      mods =
        inputs.nix-minecraft.lib.collectFilesAt modpack "mods"
        // {
          "mods/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar";
            hash = "sha256-jNvC0MC0tEil98PoAXSjlM+BXl3e6tgWBuUmZsK6ZXg=";
          };
          "mods/fastback-0.29.0+1.21.10-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ZHKrK8Rp/versions/DtjrGc8t/fastback-0.29.0%2B1.21.10-fabric.jar";
            hash = "sha256-I81490umifppBg65BB+TOsAljEz/z5ppaU8sM80/hoI=";
          };
          "mods/geyser-fabric-Geyser-Fabric-2.9.1-b999.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/WRvXSuOz/geyser-fabric-Geyser-Fabric-2.9.1-b999.jar";
            hash = "sha256-Ut1H+NI34jNjkCWS7LPgPVK1gv/WO9dWgP7kthkWVN0=";
          };
          "mods/NoChatReports-FABRIC-1.21.10-v2.16.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/78RjC1gi/NoChatReports-FABRIC-1.21.10-v2.16.0.jar";
            hash = "sha256-vTrtFM2n9ED2pAmIRGePhNv7aycwCmF1OIWATaerYuQ=";
          };
          "mods/spark-1.10.152-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/eqIoLvsF/spark-1.10.152-fabric.jar";
            hash = "sha256-Ul2oR/N2zraVvPGxWs8YbHWQu1fiBt+a9CEIUnpP/Z4=";
          };
        };
    in {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_10;
      path = with pkgs; [git git-lfs];

      jvmOpts = concatStringsSep " " [
        "-Xmx4G"
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

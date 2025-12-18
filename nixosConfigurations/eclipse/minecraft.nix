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
          "mods/geyser-fabric-Geyser-Fabric-2.9.1-b1006.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/AEbLjpyK/geyser-fabric-Geyser-Fabric-2.9.2-b1006.jar";
            hash = "sha256-NXgdh9IJ1ZS9xBIZWVKdD7tZlbeC9zTugv9mWFlwvc8=";
          };
          "mods/NoChatReports-FABRIC-1.21.10-v2.16.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/78RjC1gi/NoChatReports-FABRIC-1.21.10-v2.16.0.jar";
            hash = "sha256-vTrtFM2n9ED2pAmIRGePhNv7aycwCmF1OIWATaerYuQ=";
          };
          "mods/return-my-gold-farm-2.0.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/kuRpWzg6/versions/X5dHDFmD/return-my-gold-farm-2.0.0.jar";
            hash = "sha256-fzKQs5l9Xr5JRe63KZ7QYzRUgvPPCErqi6DWIbiPXTU=";
          };
          "mods/spark-1.10.152-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/eqIoLvsF/spark-1.10.152-fabric.jar";
            hash = "sha256-Ul2oR/N2zraVvPGxWs8YbHWQu1fiBt+a9CEIUnpP/Z4=";
          };
          "mods/worldedit-mod-7.4.0-beta-01.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/wlq4UM7x/worldedit-mod-7.4.0-beta-01.jar";
            hash = "sha256-IYfhjYxhWE9p3dRGBB+TE9UR9cgUiL/DseCWQcnRIWI=";
          };
          "mods/ViaFabricPlus-4.3.6.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/rIC2XJV4/versions/gkZyGxMz/ViaFabricPlus-4.3.6.jar";
            hash = "sha256-yZ2XaX0sYMNJGQiTXyQn910T6j4RWEF4941CBQ2rlS8=";
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

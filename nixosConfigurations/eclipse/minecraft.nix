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

  services.borgbackup.jobs.borgbase.exclude = [
    "*/DistantHorizons.sqlite"
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.forever = let
      modpack = pkgs.fetchPackwizModpack {
        name = "adrenaline-1.21.11";
        url = "https://github.com/skywardmc/adrenaline/raw/f456b9be96efaa763a57681e656d5abe34ec6c2b/versions/fabric/1.21.11/pack.toml";
        packHash = "sha256-RxixmiLyAZpSbi6fW6qEzESYIC/su9ZV+CwfDxuYgsA=";
      };

      mods =
        inputs.nix-minecraft.lib.collectFilesAt modpack "mods"
        // {
          "mods/appleskin-fabric-mc1.21.11-3.0.7.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/pvcLnrm0/appleskin-fabric-mc1.21.11-3.0.7.jar";
            hash = "sha256-UOjD6vafWRmhbMQijPq9Xzudd0E9Jng0mSw+PFGuk+0=";
          };
          "mods/dcintegration-fabric-MC1.21.10-3.1.0.1.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/rbJ7eS5V/versions/DJOsldZY/dcintegration-fabric-MC1.21.10-3.1.0.1.jar";
            hash = "sha256-2toKtlufC/oW1iK4hhQMMdp1B9NY48jYaf1g0A3ir34=";
          };
          "mods/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/GT3Bm3GN/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar";
            hash = "sha256-dpTHoX5V9b7yG0VsIqKxxOSAYLN0Z97itx1MEuWGvD8=";
          };
          "mods/fastback-0.30.0+1.21.11-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ZHKrK8Rp/versions/yqaOm9Fj/fastback-0.30.0%2B1.21.11-fabric.jar";
            hash = "sha256-/GEq3gC8QJdVbFrK5JcTQDmk+cuJX6kAkFOKfrDeEmk=";
          };
          "mods/geyser-fabric-Geyser-Fabric-2.9.2-b1039.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/KCjofoK0/geyser-fabric-Geyser-Fabric-2.9.2-b1039.jar";
            hash = "sha256-VsGJzxwMOv28Mz4rgA4Uitn6pMm/pj3UDSusd6F0QdA=";
          };
          "mods/Jade-1.21.11-Fabric-21.1.1.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/HKUAgY3D/Jade-1.21.11-Fabric-21.1.1.jar";
            hash = "sha256-TlHdOvXlmXu3MR+YRXZaTBPWq55EcF5Gdi0Y26rIDl0=";
          };
          "mods/journeymap-fabric-1.21.11-6.0.0-beta.55.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/X3DCfJx0/journeymap-fabric-1.21.11-6.0.0-beta.55.jar";
            hash = "sha256-byfc5GRBtx0jPawYPSiAgPU0KETey6ZXDOuQKPqrAQQ=";
          };
          "mods/mob_explosion_griefing-2.0.0%2B1.21.11.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l9H9JPmo/versions/Nke6FVKQ/mob_explosion_griefing-2.0.0%2B1.21.11.jar";
            hash = "sha256-1FWNrsvaWQ62VB8fR7ZxKPhu3K6U1BFaZhPfHWW2UnI=";
          };
          "mods/NoChatReports-FABRIC-1.21.11-v2.18.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/rhykGstm/NoChatReports-FABRIC-1.21.11-v2.18.0.jar";
            hash = "sha256-FIAjmJ8BT98BLlDYpDp1zErTkZn4mBT1yMo43N7+ELg=";
          };
          "mods/return-my-gold-farm-2.0.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/kuRpWzg6/versions/X5dHDFmD/return-my-gold-farm-2.0.0.jar";
            hash = "sha256-fzKQs5l9Xr5JRe63KZ7QYzRUgvPPCErqi6DWIbiPXTU=";
          };
          "mods/spark-1.10.156-fabric.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/1CB3cS0m/spark-1.10.156-fabric.jar";
            hash = "sha256-Nu0Tj/3iovH8sy7LzH+iG+rxYR4APRnjrUCVSHPlcvo=";
          };
          "mods/worldedit-mod-7.4.0.jar" = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/o645q0Oo/worldedit-mod-7.4.0.jar";
            hash = "sha256-hk6xLxIpFkNFcUORnPv2haGvpiCmXC3LN3wvIRMqDrA=";
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

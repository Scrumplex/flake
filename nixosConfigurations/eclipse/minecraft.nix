{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (inputs.nix-minecraft.lib) collectFilesAt;

  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/skywardmc/adrenaline/raw/4c72d88842c4a04b30feb0d66a486851d779f417/versions/fabric/1.21.5/pack.toml";
    packHash = "sha256-oPiO/JhidDeIJVxh4jo1domTo03h2WqX3BQNzCaWXi0=";
  };
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlays.default];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.hielke = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_5;

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
        "Aresiel" = "2295b652-0600-4212-b718-632c1181cb1f";
        "Ashtaka4" = "25cfcd78-cb4c-4d5d-ac12-2e539eb479ed";
        "Honey_Arcus" = "35ab6244-3e9e-452d-a6cd-258868d3cad7";
        "jopejoe1" = "668e7103-182c-43eb-aa4b-ca8cbc5a5e58";
        "jstsmthrgk" = "94800a68-96d2-4dcd-a2dd-cff82b5a0e4a";
        "MjolnirsRevenge" = "1f90dc25-6857-45b7-91fe-b1c905b5331d";
        "Scrumplex" = "f2873756-429d-413a-b22d-6a976ed0d3f2";
        "WaterSword" = "fb6301b9-3060-4281-bc17-503f69fb4f53";
      };

      operators = {
        "Scrumplex".uuid = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      serverProperties = {
        difficulty = "normal";
        enable-command-block = true;
        motd = "scrumplex.net";
        spawn-protection = 0;
        white-list = true;
      };

      symlinks = collectFilesAt modpack "mods";
      files = collectFilesAt modpack "config";
    };
  };

  # Some Minecraft servers leak a lot of memory.
  # We are talking about Minecraft modders here so there are infinite possibilities as to why this happens.
  # To stop the host from OOMing after some time, tell systemd to deal with this early on
  systemd.services = lib.mapAttrs' (name: _:
    lib.nameValuePair "minecraft-server-${name}" {
      serviceConfig.MemoryMax = "10G"; # kill the server if it sucks up too much
    }) (lib.filterAttrs (_: v: v.enable) config.services.minecraft-servers.servers);
}

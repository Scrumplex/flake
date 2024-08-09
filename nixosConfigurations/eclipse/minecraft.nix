{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf;

  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/skywardmc/adrenaserver/raw/c5fdf9839290173388420b4d6c328facde08e6f8/versions/fabric/1.20.6/pack.toml";
    packHash = "sha256-YN7Sdnpfa4T68LLQ/Vg/h8iyUgXwuufi5Lgg7y2FX4U=";
  };
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlays.default];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.alex = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21;
      #symlinks = {
      #  "mods" = "${modpack}/mods";
      #};

      jvmOpts = concatStringsSep " " [
        "-Xmx2G"
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

      #whitelist = {
      #  "Scrumplex" = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      #};

      serverProperties = {
        difficulty = "normal";
        motd = "scrumplex.net";
        spawn-protection = 0;
        white-list = true;
      };
    };

    servers.bee = {
      enable = false;
      package = pkgs.writeShellApplication {
        name = "minecraft-server";

        runtimeInputs = [pkgs.jdk17];

        text = ''
          exec java "$@" @libraries/net/minecraftforge/forge/1.20.1-47.2.20/unix_args.txt nogui
        '';
      };

      jvmOpts = concatStringsSep " " [
        "-Xmx6G"
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

      serverProperties = {
        # False positives
        allow-flight = true;
        difficulty = "normal";
        motd = "scrumplex.net";
        server-port = 25566;
        spawn-protection = 0;
        white-list = true;
      };
    };
  };

  # Some Minecraft servers leak a lot of memory.
  # We are talking about Minecraft modders here so there are infinite possibilities as to why this happens.
  # To stop the host from OOMing after some time, tell systemd to deal with this early on
  systemd.services."minecraft-server-alex".serviceConfig = mkIf config.services.minecraft-server.enable {
    #   MemoryHigh = "7G";
    MemoryMax = "8G"; # kill the server if it sucks up too much
  };
}

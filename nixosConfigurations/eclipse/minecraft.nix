{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib) mkIf;
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlays.default];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.alex = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_3;

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

    servers.winter-rescue = {
      enable = true;
      package = pkgs.writeShellApplication {
        name = "minecraft-server";

        runtimeInputs = [pkgs.jdk8];

        text = ''
          exec java -jar forge-1.16.5-36.2.39.jar nogui
        '';
      };

      jvmOpts = concatStringsSep " " [
        "-Xms4096M"
        "-Xmx4096M"
        "-XX:+AlwaysPreTouch"
        "-XX:+DisableExplicitGC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:+PerfDisableSharedMem"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+UseG1GC"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1NewSizePercent=30"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:G1ReservePercent=20"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:MaxGCPauseMillis=200"
        "-XX:MaxTenuringThreshold=1"
        "-XX:SurvivorRatio=32"
        "-Dusing.aikars.flags=https://mcflags.emc.gs"
        "-Daikars.new.flags=true"
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
  systemd.services."minecraft-server-winter-rescue".serviceConfig = mkIf config.services.minecraft-server.enable {
    MemoryMax = "10G"; # kill the server if it sucks up too much
  };
}

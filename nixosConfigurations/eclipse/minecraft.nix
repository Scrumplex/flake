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

    servers.atm10 = {
      enable = true;
      package = pkgs.writeShellApplication {
        name = "minecraft-server";

        runtimeInputs = [pkgs.jdk21];

        text = ''
          exec java "$@" @libraries/net/neoforged/neoforge/21.1.77/unix_args.txt nogui
        '';
      };

      jvmOpts = concatStringsSep " " [
        "-Xms4G"
        "-Xmx8G"
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
        max-tick-time = 180000;
      };
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

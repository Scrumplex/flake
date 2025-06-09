{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;

  mrpack2server21 = pkgs.fetchurl {
    url = "https://github.com/Patbox/mrpack4server/releases/download/0.5.0/mrpack4server-0.5.0.jar";
    hash = "sha256-6Jvar8Pw9cB+2RLLKca+q2FxZXmWB4DrfFtxKbuqxl8=";
  };
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlays.default];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.cobblemon = {
      enable = true;

      package = pkgs.writeShellApplication {
        name = "mrpack2server";

        runtimeInputs = [pkgs.jdk21];

        text = ''
          exec java "$@" -jar ${mrpack2server21} noGui
        '';
      };

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
        "frecked_Star" = "8c7e6c67-9f59-4f79-afcf-bdff40df6db1";
        "Honey_Arcus" = "35ab6244-3e9e-452d-a6cd-258868d3cad7";
        "Scrumplex" = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      operators = {
        "Scrumplex".uuid = "f2873756-429d-413a-b22d-6a976ed0d3f2";
      };

      serverProperties = {
        difficulty = "normal";
        enforce-secure-profile = false;
        motd = "scrumplex.net";
        spawn-protection = 0;
        white-list = true;
        allow-flight = true;
      };

      symlinks."local.mrpack" = pkgs.fetchurl {
        name = "Cobblemon-1.6.1.mrpack";
        url = "https://cdn.modrinth.com/data/5FFgwNNP/versions/cqaC80tF/Cobblemon%20Official%20%5BFabric%5D%201.6.1.mrpack";
        hash = "sha256-U22WX5eL8oQb2YJSyOkP4v+ndOJyFiEu345tR8OtOXo=";
      };
      symlinks."mods/ftb-library-fabric.jar" = pkgs.fetchurl {
        url = "https://mediafilez.forgecdn.net/files/6466/107/ftb-library-fabric-2101.1.13.jar";
        hash = "sha256-Zbb8+h/q6OgV180wMdf1KR3k4Y+gWQsM/co9i4KbG4A=";
      };
      symlinks."mods/ftb-ultimine-fabric.jar" = pkgs.fetchurl {
        url = "https://mediafilez.forgecdn.net/files/6607/450/ftb-ultimine-fabric-2101.1.3.jar";
        hash = "sha256-gWn6l85MuSdWQNuErKvDTOX2Q/ZsUUsi4V8Mu5ibfjs=";
      };
      symlinks."mods/cobblemonrider.jar" = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/ZLu8WiYO/versions/HPaVdg1v/cobblemonridingfabric-1.3.7.jar";
        hash = "sha256-F95Zj6C87+fBnR8Rj0o2naAk/peFPKPrtScu2d/zymw=";
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

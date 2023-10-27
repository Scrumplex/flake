{pkgs, ...}: let
  inherit (builtins) concatStringsSep;
in {
  services.minecraft-server = {
    enable = true;
    eula = true;

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

    package = pkgs.writeShellApplication {
      name = "minecraft-server";

      runtimeInputs = [pkgs.graalvm17-ce];

      text = ''
        exec java "$@" @libraries/net/minecraftforge/forge/1.20.1-47.1.3/unix_args.txt nogui
      '';
    };

    openFirewall = true;
  };

  # Some Minecraft servers leak a lot of memory.
  # We are talking about Minecraft modders here so there are infinite possibilities as to why this happens.
  # To stop the host from OOMing after some time, tell systemd to deal with this early on
  systemd.services."minecraft-server".serviceConfig = {
    MemoryHigh = "7G";
    MemoryMax = "8G"; # kill the server if it sucks up too much
  };
}

{...}: {
  services.teamspeak3 = {
    enable = true;
    openFirewall = true;
  };

  systemd.services."teamspeak3-server".serviceConfig = {
    # Hardening
    CapabilityBoundingSet = "";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;

    PrivateDevices = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RestrictNamespaces = true;
    RestrictRealtime = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"
      "~@privileged"
    ];
  };
}

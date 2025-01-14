{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) literalExpression mkEnableOption mkIf mkOption types;

  cfg = config.services.hetzner-dyndns;

  updateScript =
    pkgs.callPackage
    ({
      writeShellApplication,
      curl,
      jq,
    }:
      writeShellApplication {
        name = "update-hetzner-dns";

        runtimeInputs = [curl jq];

        text = ''
          ipLookupAddress="https://checkip.amazonaws.com"
          ipAddress=$(curl -L "$ipLookupAddress")

          zoneId=$(curl "https://dns.hetzner.com/api/v1/zones?search_name=$HETZNER_ZONE" \
            -H "Auth-API-Token: $HETZNER_TOKEN"  | jq -r ".zones[0].id")

          recordId=$(curl "https://dns.hetzner.com/api/v1/records?zone_id=$zoneId" \
            -H "Auth-API-Token: $HETZNER_TOKEN" | jq -r "(.records[] | select( .name == \"$HETZNER_RECORD\" and .type == \"A\" )).id")

          curl -X PUT "https://dns.hetzner.com/api/v1/records/$recordId" \
            -H "Auth-API-Token: $HETZNER_TOKEN" \
            -H "Content-Type: application/json" \
            -d "{ \"value\": \"$ipAddress\", \"ttl\": 300, \"type\": \"A\", \"name\": \"$HETZNER_RECORD\", \"zone_id\": \"$zoneId\"}"
        '';
      })
    {};
in {
  options.services.hetzner-dyndns = {
    enable = mkEnableOption "hetzner-dyndns";

    environmentFile = mkOption {
      description = ''
        Path to environment file containing HETZNER_TOKEN, HETZNER_ZONE and HETZNER_RECORD
      '';
      type = with types; nullOr path;
      example = literalExpression ''config.age.secrets."hetzner-dyndns.env".path'';
      default = null;
    };
  };

  config = mkIf cfg.enable {
    systemd.services."hetzner-dyndns" = {
      description = "Hetzner dynamic DNS updater";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe updateScript;
        EnvironmentFile = mkIf (cfg.environmentFile != null) [cfg.environmentFile];

        DynamicUser = true;
        NoNewPrivileges = true;
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
      };
    };
    systemd.timers."hetzner-dyndns" = {
      timerConfig = {
        OnCalendar = "*:0/5";
        RandomizedDelaySec = "1m";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}

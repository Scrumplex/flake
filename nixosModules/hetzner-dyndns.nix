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
      hcloud,
    }:
      writeShellApplication {
        name = "update-hetzner-dns";

        runtimeInputs = [curl hcloud];

        text = ''
          ipLookupAddress="https://checkip.amazonaws.com"
          ipAddress=$(curl -L "$ipLookupAddress")

          hcloud zone set-records "$HETZNER_ZONE" "$HETZNER_RECORD" A --record "$ipAddress"
        '';
      })
    {};
in {
  options.services.hetzner-dyndns = {
    enable = mkEnableOption "hetzner-dyndns";

    zone = mkOption {
      type = with types; str;
      default = null;
      description = "Name of the zone to modify.";
      example = "example.tld";
    };

    record = mkOption {
      type = with types; str;
      default = null;
      description = "Name of the record to modify.";
      example = "server";
    };

    environmentFile = mkOption {
      description = ''
        Path to environment file containing HCLOUD_TOKEN
      '';
      type = with types; nullOr path;
      example = literalExpression ''config.age.secrets."hetzner-dyndns.env".path'';
      default = null;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.zone != null;
        message = "services.hetzner-dyndns.zone has to be set.";
      }
      {
        assertion = cfg.record != null;
        message = "services.hetzner-dyndns.record has to be set.";
      }
    ];

    systemd.services."hetzner-dyndns" = {
      description = "Hetzner dynamic DNS updater";
      environment = {
        HETZNER_ZONE = cfg.zone;
        HETZNER_RECORD = cfg.record;
      };
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

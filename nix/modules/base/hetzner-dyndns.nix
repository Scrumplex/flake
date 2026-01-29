{
  flake.modules.nixos."base" = {
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
        curl,
        hcloud,
        iproute2,
        jq,
        writeShellApplication,
      }:
        writeShellApplication {
          name = "update-hetzner-dns";

          runtimeInputs = [curl hcloud iproute2 jq];

          text = ''
            ipv4Address=$(curl --ipv4 --silent --location "http://myip.wtf/text")

            echo "Got IPv4: $ipv4Address"

            hcloud zone set-records "$HETZNER_ZONE" "$HETZNER_RECORD" A --record "$ipv4Address"

            ipv6Addr() {
              if [ -n "$IPV6_INTERFACE" ]; then
                ip -json -6 address show dev "$IPV6_INTERFACE" "$@"
              else
                ip -json -6 address show "$@"
              fi
            }

            if [ "$ENABLE_IPV6" == "true" ]; then
              # Extract latest global IPv6 address, that isn't in a ULA prefix
              ipv6Address=$(ipv6Addr scope global mngtmpaddr | jq --raw-output '[.[].addr_info[] | select(.local) | select(.local | startswith("fd") == false)] | sort_by(.preferred_life_time) | last | .local')

              echo "Got IPv6: $ipv6Address"

              hcloud zone set-records "$HETZNER_ZONE" "$HETZNER_RECORD" AAAA --record "$ipv6Address"
            fi
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

      ipv6 = {
        enable = mkEnableOption "IPv6 support";

        interface = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "ens0";
          description = ''
            Interface to query IPv6 addresses on.

            May be null to check all interfaces. Note that the longest
            preferred_life_time is used to determine which one to use.
          '';
        };
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
          ENABLE_IPV6 = lib.boolToString cfg.ipv6.enable;
          IPV6_INTERFACE = toString cfg.ipv6.interface;
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
  };
}

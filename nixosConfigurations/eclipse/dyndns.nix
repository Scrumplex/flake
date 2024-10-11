{
  config,
  lib,
  pkgs,
  ...
}: let
  updateScript =
    pkgs.callPackage
    ({
      writeShellApplication,
      curl,
      iproute2,
      jq,
      lexicon,
    }:
      writeShellApplication {
        name = "update-hetzner-dns";

        runtimeInputs = [curl iproute2 jq lexicon];

        text = ''
          v4Address=$(curl -4sSL "https://myip.wtf/text")
          v6Address=$(ip -j -6 address show mngtmpaddr dynamic | jq -r '.[0].addr_info[] | select(.local) | .local')

          echo "Setting records to"
          echo " $v4Address"
          echo " $v6Address"

          if [ -z "$LEXICON_HETZNER_TOKEN" ]; then
            echo "No auth token set. Please set LEXICON_HETZNER_TOKEN." 1>&2
            exit 1
          fi

          lexicon hetzner update "$HETZNER_ZONE" A --name "$HETZNER_RECORD" --ttl 300 --content "$v4Address"
          lexicon hetzner update "$HETZNER_ZONE" AAAA --name "$HETZNER_RECORD" --ttl 300 --content "$v6Address"
        '';
      })
    {};
in {
  age.secrets."hetzner-ddns.env".file = ../../secrets/eclipse/hetzner-ddns.env.age;

  systemd.services."hetzner-ddns" = {
    description = "Hetzner dynamic DNS updater";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe updateScript;
      EnvironmentFile = [config.age.secrets."hetzner-ddns.env".path];

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
  systemd.timers."hetzner-ddns" = {
    timerConfig = {
      OnCalendar = "*:0/5";
      RandomizedDelaySec = "1m";
    };
    wantedBy = ["multi-user.target"];
  };
}

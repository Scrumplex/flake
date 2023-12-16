{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe';

  renovateConfig = pkgs.writeText "renovate.json" (builtins.toJSON {
    platform = "gitea";
    endpoint = "https://codeberg.org/api/v1";
    gitAuthor = "Skippy <renovate@scrumplex.net>";
    onboardingConfig = {
      "$schema" = "https://docs.renovatebot.com/renovate-schema.json";
      extends = ["config:recommended"];
    };
    onboardingNoDep = true;

    repositories = [
      "Scrumplex/flake"
      "Scrumplex/duckhub-static"
      "Scrumplex/honeylinks"
      "Scrumplex/infrastructure"
      "Scrumplex/inhibridge"
      "Scrumplex/prntserve"
      "Scrumplex/skinprox"
      "Scrumplex/website"
    ];
  });
in {
  virtualisation.podman.enable = true;

  age.secrets."renovate.env".file = ../../secrets/universe/renovate.env.age;

  systemd.services."renovate" = {
    description = "Renovate Bot";
    environment.PODMAN_SYSTEMD_UNIT = "%n";
    serviceConfig = {
      Type = "notify";
      ExecStart = ''
        ${getExe' pkgs.podman "podman"} run \
          --name=renovate \
          --volume=${renovateConfig}:/usr/src/app/config.json \
          --env=RENOVATE_CONFIG_FILE=/usr/src/app/config.json \
          --env-file=${config.age.secrets."renovate.env".path} \
          --rm --replace --detach --sdnotify=conmon --cgroups=no-conmon \
          ${config.virtualisation.oci-containers.externalImages.images."renovate".ref}
      '';
      NotifyAccess = "all";
      RestartSec = "10s";
      Restart = "on-abnormal";
    };
  };

  systemd.timers."renovate" = {
    timerConfig = {
      OnCalendar = "hourly";
      RandomizedDelaySec = "1m";
    };
    wantedBy = ["multi-user.target"];
  };
}

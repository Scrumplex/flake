{
  config,
  pkgs,
  ...
}: {
  age.secrets."renovate.env".file = ../../secrets/universe/renovate.env.age;

  services.renovate = {
    enable = true;
    schedule = "hourly";
    settings = {
      platform = "gitea";
      endpoint = "https://codeberg.org/api/v1";
      gitAuthor = "Skippy <renovate@scrumplex.net>";
      onboardingConfig = {
        "$schema" = "https://docs.renovatebot.com/renovate-schema.json";
        extends = ["config:recommended"];
      };
      onboardingNoDeps = true;

      repositories = [
        "Scrumplex/flake"
        "Scrumplex/duckhub-static"
        "Scrumplex/honeylinks"
        "Scrumplex/infrastructure"
        "Scrumplex/inhibridge"
        "Scrumplex/skinprox"
        "Scrumplex/website"
      ];
    };
    runtimePackages = with pkgs; [
      config.nix.package
      nodejs
      corepack
    ];
  };

  systemd.services."renovate".serviceConfig.EnvironmentFile = [
    config.age.secrets."renovate.env".path
  ];
  systemd.timers."renovate".timerConfig.RandomizedDelaySec = "5m";
}

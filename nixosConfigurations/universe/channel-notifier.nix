{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets."channel-notifier.env".file = ../../secrets/universe/channel-notifier.env.age;

  systemd.services."channel-notifier" = {
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    startAt = "5m";
    serviceConfig = {
      ExecStart = lib.getExe pkgs.channel-notifier;
      EnvironmentFile = [config.age.secrets."channel-notifier.env".path];
      StateDirectory = "channel-notifier";
      DynamicUser = true;
    };
  };
}

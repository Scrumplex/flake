{config, ...}: let
  user = config.systemd.services.hercules-ci-agent.serviceConfig.User;
  group = config.users.users.${user}.group;
in {
  age.secrets."hercules-caches.json" = {
    file = ../../secrets/eclipse/hercules-caches.json.age;
    owner = user;
    inherit group;
  };
  age.secrets."hercules-token" = {
    file = ../../secrets/eclipse/hercules-token.age;
    owner = user;
    inherit group;
  };

  services.hercules-ci-agent = {
    enable = true;
    settings = {
      binaryCachesPath = config.age.secrets."hercules-caches.json".path;
      clusterJoinTokenPath = config.age.secrets."hercules-token".path;
    };
  };
}

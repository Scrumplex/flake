{config, ...}: {
  age.secrets."beets-secrets.yaml" = {
    file = ../secrets/common/beets-secrets.yaml.age;
    owner = config.roles.base.username;
  };
  age.secrets."listenbrainz-token" = {
    file = ../secrets/common/listenbrainz-token.age;
    owner = config.roles.base.username;
  };

  hm.imports = [./common ./${config.networking.hostName}];
}

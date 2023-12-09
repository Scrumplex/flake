{config, ...}: {
  age.secrets."beets-secrets.yaml" = {
    file = ../secrets/common/beets-secrets.yaml.age;
    owner = config.primaryUser.name;
  };
  age.secrets."listenbrainz-token" = {
    file = ../secrets/common/listenbrainz-token.age;
    owner = config.primaryUser.name;
  };

  hm.imports = [./common ./${config.networking.hostName}];
}

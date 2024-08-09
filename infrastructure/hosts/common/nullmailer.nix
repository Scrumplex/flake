{config, ...}: {
  age.secrets."nullmailer-remotes" = {
    file = ../../secrets/common/nullmailer-remotes.age;
    owner = config.services.nullmailer.user;
    group = config.services.nullmailer.group;
  };

  services.nullmailer = {
    enable = true;
    remotesFile = config.age.secrets."nullmailer-remotes".path;
    config = {
      me = "${config.networking.fqdnOrHostName}";
      allmailfrom = "notify@sefa.cloud";
      adminaddr = "contact@scrumplex.net";
    };
  };
}

{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.typhon-ci.nixosModules.default
  ];

  age.secrets."typhon-admin" = {
    file = ../../secrets/eclipse/typhon-admin.age;
    owner = config.systemd.services."typhon".serviceConfig.User;
    group = config.systemd.services."typhon".serviceConfig.Group;
  };

  services.typhon = {
    enable = true;
    hashedPasswordFile = config.age.secrets."typhon-admin".path;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.typhon = {
      entryPoints = ["websecure"];
      service = "typhon";
      rule = "Host(`typhon.sefa.cloud`)";
    };
    services.typhon.loadBalancer.servers = [{url = "http://localhost:3000";}];
  };
}

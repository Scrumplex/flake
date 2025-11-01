{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.buildbot-nix.nixosModules.buildbot-master inputs.buildbot-nix.nixosModules.buildbot-worker];

  age.secrets."codeberg-oauth-secret".file = ../../secrets/eclipse/codeberg-oauth-secret.age;
  age.secrets."codeberg-webhook-secret".file = ../../secrets/eclipse/codeberg-webhook-secret.age;
  age.secrets."codeberg-token".file = ../../secrets/eclipse/codeberg-token.age;

  services.buildbot-nix.master = {
    enable = true;
    domain = "buildbot.sefa.cloud";
    workersFile = pkgs.writeText "workers.json" (builtins.toJSON [
      {
        name = "eclipse";
        pass = "hunter2";
        cores = 16;
      }
    ]);
    admins = [
      "Scrumplex"
    ];
    authBackend = "gitea";
    gitea = {
      enable = true;
      instanceUrl = "https://codeberg.org";
      oauthId = "76afb1cd-67df-40e1-8fba-e1becfc91b67";
      oauthSecretFile = config.age.secrets."codeberg-oauth-secret".path;
      webhookSecretFile = config.age.secrets."codeberg-webhook-secret".path;
      tokenFile = config.age.secrets."codeberg-token".path;
      topic = "use-buildbot";
    };
    useHTTPS = true;
    buildSystems = ["x86_64-linux"];
  };
  services.buildbot-nix.worker = {
    enable = true;
    workerPasswordFile = pkgs.writeText "worker-password" "hunter2";
  };

  services.nginx.enable = lib.mkForce false;

  services.traefik.dynamicConfigOptions.http = {
    routers.buildbot = {
      entryPoints = ["websecure"];
      service = "buildbot";
      rule = "Host(`buildbot.sefa.cloud`)";
    };
    services.buildbot.loadBalancer.servers = [{url = "http://localhost:${toString config.services.buildbot-master.port}";}];
  };
}

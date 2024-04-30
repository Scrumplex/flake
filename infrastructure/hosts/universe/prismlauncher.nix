{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.prism-meta.nixosModules.default
    inputs.refraction.nixosModules.default
  ];

  nixpkgs.overlays = [inputs.refraction.overlays.default];

  age.secrets."prism-meta.key" = {
    file = ../../secrets/universe/prism-meta.key.age;
    owner = "blockgame-meta";
    group = "blockgame-meta";
  };

  age.secrets."prism-refraction.env" = {
    file = ../../secrets/universe/prism-refraction.env.age;
    owner = config.services.refraction.user;
    inherit (config.services.refraction) group;
  };

  services.blockgame-meta = {
    enable = true;
    settings = {
      DEPLOY_TO_GIT = "true";
      GIT_AUTHOR_NAME = "PrismAutomata";
      GIT_AUTHOR_EMAIL = "gitbot@scrumplex.net";
      GIT_COMMITTER_NAME = "PrismAutomata";
      GIT_COMMITTER_EMAIL = "gitbot@scrumplex.net";
      GIT_SSH_COMMAND = "ssh -i ${config.age.secrets."prism-meta.key".path}";
    };
  };

  services.nginx = {
    upstreams.prismlogs.servers."localhost:4180" = {};
    virtualHosts."logs.prismlauncher.org" = lib.mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      {
        locations."/".proxyPass = "http://prismlogs";
      }
    ];
  };

  services.refraction = {
    enable = true;
    package = pkgs.refraction; # overlay
    environmentFile = config.age.secrets."prism-refraction.env".path;
  };
}

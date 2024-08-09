{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.prism-meta.nixosModules.default
  ];

  age.secrets."prism-meta.key" = {
    file = ../../../secrets/universe/prism-meta.key.age;
    owner = "blockgame-meta";
    group = "blockgame-meta";
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
}

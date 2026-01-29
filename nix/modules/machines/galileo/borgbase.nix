{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    age.secrets."id_borgbase".file = ./id_borgbase.age;

    infra.borgbase = {
      enable = true;
      repo = "ssh://gils6l68@gils6l68.repo.borgbase.com/./repo";
      sshKeyFile = config.age.secrets.id_borgbase.path;
    };
  };
}

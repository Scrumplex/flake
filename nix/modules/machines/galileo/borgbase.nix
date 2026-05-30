{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    age.secrets."id_borgbase".file = ./id_borgbase.age;

    infra.borg-rsync-net = {
      enable = true;
      sshKeyFile = config.age.secrets.id_borgbase.path;
    };
  };
}

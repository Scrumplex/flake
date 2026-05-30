{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    infra.borg-rsync-net.extraExcludes = [
      config.services.syncthing.dataDir
    ];
  };
}

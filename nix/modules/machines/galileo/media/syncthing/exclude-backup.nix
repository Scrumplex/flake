{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    services.borgbackup.jobs.borgbase.exclude = [
      config.services.syncthing.dataDir
    ];
  };
}

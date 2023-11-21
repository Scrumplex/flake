{
  config,
  lib,
  ...
}: {
  services.borgbackup.jobs.borgbase = {
    environment.BORG_RSH = "ssh -i ${config.age.secrets.id_borgbase.path}";
    paths = ["/srv" "/var/lib" "/home" "/root"];
    exclude = ["/var/lib/docker" "/var/lib/kubelet"];
    startAt = "05:00"; # run later, maybe the servers are overloaded at 00:00 CE(S)T
    compression = "auto,zstd";
    prune.keep = {
      within = "1d";
      daily = 3;
      weekly = 4;
      monthly = 6;
      yearly = 2;
    };
    encryption = {
      mode = lib.mkDefault "keyfile-blake2";
      passphrase = "";
    };

    extraArgs = "-v";
    extraCreateArgs = "--stats";
  };
}

{ config, pkgs, lib, ... }:

{
  services.borgbackup.jobs.borgbase = {
    environment.BORG_RSH = "ssh -i ${config.age.secrets.id_borgbase.path}";
    paths = [ "/srv" "/var/lib" ];
    startAt =
      "05:00"; # run later, maybe the servers are overloaded at 00:00 CE(S)T
    compression = "auto,zstd";
    prune.keep = {
      within = "1d";
      daily = 3;
      weekly = 4;
      monthly = 6;
      yearly = 2;
    };
    encryption = {
      mode = "keyfile-blake2";
      passphrase = "";
    };
  };
}

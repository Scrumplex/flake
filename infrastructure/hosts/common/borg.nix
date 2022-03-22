{  config, pkgs, lib, ... }:

{
  services.borgbackup.jobs.borgbase = {
    environment.BORG_RSH = "ssh -i ${config.age.secrets.id_borgbase.path}";
    paths = [
      "/home"
      "/root"
      "/srv"
      "/var/lib"
    ];
    startAt = "05:00";  # run later, maybe the servers are overloaded at 00:00 CE(S)T
    compression = "auto,zstd";
    prune.keep = {
      within = "1d";
      daily = 3;
      weekly = 4;
      monthly = 12;
      yearly = 2;
    };
    encryption = {
      mode = "keyfile-blake2";
      passphrase = "";
    };
  };

  systemd.services."borgbackup-job-borgbase" = {
    after = [ "id_borgbase-key.service" ];
    wants = [ "id_borgbase-key.service" ];
  };
  systemd.timers."borgbackup-job-borgbase" = {
    after = [ "id_borgbase-key.service" ];
    wants = [ "id_borgbase-key.service" ];
  };
}

{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  disabledModules = ["services/backup/postgresql-backup.nix"];
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"

    ../../postgresql-backup.nix
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/netcup.nix
    ../common/borg.nix
    ../common/nix.nix
    ../common/nullmailer.nix
    ../common/traefik.nix

    ./containers.nix
    ./murmur.nix
    ./renovate.nix
    ./skinprox.nix
    ./synapse.nix
    ./teamspeak3.nix
    ./wireguard.nix
  ];

  age.secrets.id_borgbase.file = ../../secrets/universe/id_borgbase.age;
  age.secrets.borgbase_repokey.file = ../../secrets/universe/borgbase_repokey.age;
  age.secrets."wireguard.key".file = ../../secrets/universe/wireguard.key.age;
  age.secrets."hetzner.key".file = ../../secrets/universe/hetzner.key.age;

  netcup.bootMode = "uefi";

  networking = {
    hostName = "universe";
    domain = "scrumplex.net";
    interfaces.ens3.ipv6 = {
      addresses = [
        {
          address = "2a03:4000:41:ef:8238:c03b:a699:0288";
          prefixLength = 64;
        }
      ];
      routes = [
        {
          address = "::";
          prefixLength = 0;
          via = "fe80::1";
        }
      ];
    };

    firewall = {
      allowedTCPPorts = [
        # OME
        3478

        # ts3
        41144
      ];
      allowedUDPPorts = [
        # ts3
        9987

        # OME
        10000
        10001
        10002
        10003
        10004
        10005
      ];
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    extraPlugins = [config.services.postgresql.package.pkgs.pg_repack];
  };
  services.postgresqlBackup = {
    enable = true;
    compressionRsyncable = true;
  };

  # TODO
  services.borgbackup.jobs.borgbase = {
    repo = "ssh://yekr15ge@yekr15ge.repo.borgbase.com/./repo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets.borgbase_repokey.path}";
    };
    paths = [config.services.postgresqlBackup.location];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

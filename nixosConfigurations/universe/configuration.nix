{
  config,
  fpConfig,
  inputs,
  ...
}: {
  imports = [
    ./channel-notifier.nix
    ./disks.nix
    ./honeylinks-website.nix
    ./monitoring.nix
    ./murmur.nix
    ./postgres.nix
    ./renovate.nix
    ./scrumplex-website.nix
    ./scrumplex-x.nix
    ./skinprox.nix
    ./synapse.nix
    ./teamspeak3.nix
    ./wireguard.nix

    fpConfig.flake.modules.nixos.server

    inputs.nixos-facter-modules.nixosModules.facter
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.mixins-systemd-boot
  ];

  facter.reportPath = ./facter.json;

  age.secrets.id_borgbase.file = ../../secrets/universe/id_borgbase.age;
  age.secrets.borgbase_repokey.file = ../../secrets/universe/borgbase_repokey.age;

  infra.borgbase = {
    enable = true;
    repo = "ssh://yekr15ge@yekr15ge.repo.borgbase.com/./repo";
    sshKeyFile = config.age.secrets.id_borgbase.path;
    repokeyPasswordFile = config.age.secrets.borgbase_repokey.path;
  };
  srvos.boot.consoles = ["tty0"];

  netcup.bootMode = "uefi";

  networking = {
    hostName = "universe";
    domain = "scrumplex.net";
    interfaces.ens3.ipv6 = {
      addresses = [
        {
          address = "2a03:4000:7:7a3:8238:c03b:a699:288";
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
      ];
      allowedUDPPorts = [
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

  system.stateVersion = "25.05";
}

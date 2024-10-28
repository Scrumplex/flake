{
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}: let
  inherit (inputs) srvos;
in {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"

    ./hardware-configuration.nix
    ./honeylinks-website.nix
    ./monitoring.nix
    ./murmur.nix
    ./postgres.nix
    ./prismlauncher
    ./renovate.nix
    ./scrumplex-website.nix
    ./scrumplex-x.nix
    ./skinprox.nix
    ./synapse.nix
    ./teamspeak3.nix
    ./wireguard.nix

    srvos.nixosModules.server
    srvos.nixosModules.mixins-systemd-boot
  ];

  age.secrets.id_borgbase.file = ../../secrets/universe/id_borgbase.age;
  age.secrets.borgbase_repokey.file = ../../secrets/universe/borgbase_repokey.age;
  age.secrets."wireguard.key".file = ../../secrets/universe/wireguard.key.age;

  infra.borgbase = {
    enable = true;
    repo = "ssh://yekr15ge@yekr15ge.repo.borgbase.com/./repo";
    sshKeyFile = config.age.secrets.id_borgbase.path;
    repokeyPasswordFile = config.age.secrets.borgbase_repokey.path;
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

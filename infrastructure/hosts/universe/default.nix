{config, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/netcup.nix
    ../common/borg.nix
    ../common/nix.nix
    ../common/nullmailer.nix
    ../common/traefik.nix

    ./containers.nix
    ./murmur.nix
    ./skinprox.nix
    ./teamspeak3.nix
    ./wireguard.nix
  ];

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

        # synapse
        8448

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

  services.traefik.staticConfigOptions.entryPoints.synapsesecure =
    config.services.traefik.staticConfigOptions.entryPoints.websecure
    // {
      address = ":8448";
    };

  # TODO
  services.borgbackup.jobs.borgbase = {
    repo = "ssh://yekr15ge@yekr15ge.repo.borgbase.com/./repo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets.borgbase_repokey.path}";
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

{...}: {
  imports = [
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/netcup.nix
    ../common/borg.nix
    ../common/nix.nix
    ../common/traefik.nix

    ./containers.nix
    ./murmur.nix
    ./wireguard.nix
  ];

  networking = {
    hostName = "spacehub";
    interfaces.ens3.ipv6.addresses = [
      {
        address = "2a03:4000:60:e31:8238:c03b:a699:0288";
        prefixLength = 64;
      }
    ];
    interfaces.ens3.ipv6.routes = [
      {
        address = "::";
        prefixLength = 0;
        via = "fe80::1";
      }
    ];

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

  services.borgbackup.jobs.borgbase.repo = "j0b0k0o5@j0b0k0o5.repo.borgbase.com:repo";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

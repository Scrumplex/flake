{...}: {
  imports = [
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/netcup.nix
    ../common/borg.nix
    ../common/traefik.nix

    ./traefik.nix # our overrides
    ./wireguard.nix
  ];

  networking = {
    hostName = "duckhub";
    interfaces.ens3.ipv6.addresses = [
      {
        address = "2a03:4000:60:e42:a85d:7ff:feae:a374";
        prefixLength = 64;
      }
    ];
  };

  services.borgbackup.jobs.borgbase.repo = "e629u305@e629u305.repo.borgbase.com:repo";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

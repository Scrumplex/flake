{...}: {
  imports = [
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/netcup.nix
    ../common/nix.nix
  ];

  networking = {
    hostName = "spacehub";
    domain = "scrumplex.net";
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
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIND05tH+7T3opok0hT3I6JgYvkzl1yoeepGWZotq5vfI root@universe"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

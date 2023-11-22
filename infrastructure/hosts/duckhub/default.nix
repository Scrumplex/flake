{...}: {
  imports = [
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/netcup.nix
    ../common/borg.nix
    ../common/nix.nix
    ../common/nullmailer.nix
    ../common/traefik.nix

    ./traefik.nix # our overrides
    ./wireguard.nix
  ];

  networking = {
    hostName = "duckhub";
    domain = "scrumplex.net";
    interfaces.ens3.ipv6.addresses = [
      {
        address = "2a03:4000:60:e42:a85d:7ff:feae:a374";
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

  networking.hosts = {
    "85.209.51.237" = ["duckhub.io" "quack.duckhub.io"];
    "2a03:4000:41:ef:8238:c03b:a699:288" = ["duckhub.io" "quack.duckhub.io"];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.duckhub = {
      entryPoints = ["websecure" "synapsesecure"];
      service = "duckhub";
      rule = "Host(`duckhub.io`)";
    };
    routers.duckhub2 = {
      entryPoints = ["synapsesecure"];
      service = "duckhub2";
      rule = "Host(`duckhub.io`)";
    };
    routers.qduckhub = {
      entryPoints = ["websecure" "synapsesecure"];
      service = "qduckhub";
      rule = "Host(`quack.duckhub.io`)";
    };
    services.duckhub.loadBalancer.servers = [{url = "https://duckhub.io";}];
    services.duckhub2.loadBalancer.servers = [{url = "https://duckhub.io:8448";}];
    services.qduckhub.loadBalancer.servers = [{url = "https://quack.duckhub.io";}];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIND05tH+7T3opok0hT3I6JgYvkzl1yoeepGWZotq5vfI root@universe"
  ];

  services.borgbackup.jobs.borgbase.repo = "e629u305@e629u305.repo.borgbase.com:repo";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

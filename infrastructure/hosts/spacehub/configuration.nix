{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix

      ../common/common.nix
      ../common/netcup.nix
      ../common/borg.nix
      ../common/traefik.nix
      ../common/sslh.nix

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

    firewall = {
      allowedTCPPorts = [
        # ts3
        41144

        # murmur
        64738
      ];
      allowedUDPPorts = [
        # srt
        1935

        # ts3
        9987

        # murmur
        64738
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


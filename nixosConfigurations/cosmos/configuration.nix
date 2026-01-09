{
  config,
  fpConfig,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) srvos nixos-hardware;
in {
  imports = [
    ./boot.nix
    ./dyndns.nix
    ./home-assistant
    ./traefik.nix
    ./wifi.nix
    ./wireguard.nix

    fpConfig.flake.modules.nixos.raspberry-pi-4
    fpConfig.flake.modules.nixos.ext-docker
    fpConfig.flake.modules.nixos.machine-cosmos

    srvos.nixosModules.server
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  hardware.facter = {
    reportPath = ./facter.json;
    detected.dhcp.enable = false;
  };

  age.secrets.id_borgbase.file = ../../secrets/cosmos/id_borgbase.age;

  infra.borgbase = {
    enable = true;
    repo = "ssh://gils6l68@gils6l68.repo.borgbase.com/./repo";
    sshKeyFile = config.age.secrets.id_borgbase.path;
  };

  networking = {
    hostName = "cosmos";
    domain = "lan";

    useDHCP = false;
    interfaces.end0.useDHCP = true;

    firewall = {
      allowedTCPPorts = [
        4242
      ];
    };
  };

  systemd.network.networks."40-end0" = {
    dhcpV4Config.RouteMetric = 1024;
    ipv6AcceptRAConfig.RouteMetric = 1024;
  };

  environment.systemPackages = with pkgs; [
    iw
    ethtool
  ];

  users.users.scrumplex = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys =
      config.users.users.root.openssh.authorizedKeys.keys
      ++ [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUfcVT3WxnuIWGxdmGiZMXZ5wsnQXqL+HO0ZIQS7wKL"
      ];
    hashedPassword = "$y$j9T$JbosTEvX3uH6.mFV/Sz071$6vVkITFq4INQFdf51.guqaD68JWp6ZcVNGVfPqqIzL/";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  system.stateVersion = "23.05";
}

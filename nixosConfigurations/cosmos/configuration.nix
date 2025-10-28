{
  config,
  fpConfig,
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) srvos nixos-hardware;
in {
  imports = [
    ./boot.nix
    ./dyndns.nix
    ./hardware-configuration.nix
    ./home-assistant.nix
    ./traefik.nix
    ./wifi.nix
    ./wireguard.nix

    fpConfig.flake.modules.nixos.raspberry-pi-4
    fpConfig.flake.modules.nixos.ext-docker

    srvos.nixosModules.server
    nixos-hardware.nixosModules.raspberry-pi-4
    inputs.nixos-facter-modules.nixosModules.facter
  ];

  facter.reportPath = ./facter.json;

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

  system.stateVersion = "23.05";
}

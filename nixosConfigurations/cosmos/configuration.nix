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
    ./wireguard.nix

    fpConfig.flake.modules.nixos.server
    fpConfig.flake.modules.nixos.ext-docker

    srvos.nixosModules.server
    nixos-hardware.nixosModules.raspberry-pi-4
    inputs.nixos-facter-modules.nixosModules.facter
  ];

  facter.reportPath = ./facter.json;

  age.secrets.id_borgbase.file = ../../secrets/cosmos/id_borgbase.age;
  age.secrets."wpa_supplicant.conf".file = ../../secrets/cosmos/wpa_supplicant.conf.age;

  infra.borgbase = {
    enable = true;
    repo = "ssh://gils6l68@gils6l68.repo.borgbase.com/./repo";
    sshKeyFile = config.age.secrets.id_borgbase.path;
  };

  networking = {
    hostName = "cosmos";
    domain = "lan";
    interfaces.end0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless = {
      enable = true;
      secretsFile = config.age.secrets."wpa_supplicant.conf".path;
      networks."Beehive".pskRaw = "ext:psk_Beehive";
    };

    firewall = {
      allowedTCPPorts = [
        4242
      ];
    };
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

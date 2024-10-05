{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (builtins) readFile;
  inherit (inputs) srvos nixos-hardware;
in {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./home-assistant.nix
    ./otel.nix
    ./traefik.nix
    ./wireguard.nix

    srvos.nixosModules.server
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  age.secrets.id_borgbase.file = ../../secrets/cosmos/id_borgbase.age;
  age.secrets."wireguard.key".file = ../../secrets/cosmos/wireguard.key.age;
  age.secrets."hetzner.key".file = ../../secrets/cosmos/hetzner.key.age;

  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;

  infra.borgbase = {
    enable = true;
    repo = "ssh://gils6l68@gils6l68.repo.borgbase.com/./repo";
    sshKeyFile = config.age.secrets.id_borgbase.path;
  };

  profile.nix.enableMyCache = true;

  networking = {
    hostName = "cosmos";
    domain = "sefa.cloud";
    interfaces.end0.useDHCP = true;

    firewall = {
      allowedTCPPorts = [
        4242
      ];
    };
  };

  security.pki.certificates = [
    (readFile ../../extra/ca_root.crt)
  ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [
        "--all"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    stow
  ];

  users.users.scrumplex = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys =
      config.users.users.root.openssh.authorizedKeys.keys
      ++ [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUfcVT3WxnuIWGxdmGiZMXZ5wsnQXqL+HO0ZIQS7wKL"
      ];
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  system.stateVersion = "23.05";
}

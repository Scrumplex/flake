{
  config,
  inputs,
  ...
}: let
  inherit (inputs) nixos-hardware srvos;
in {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./buildbot.nix
    ./dyndns.nix
    ./firefly-iii.nix
    ./frigate.nix
    ./immich.nix
    ./media
    ./minecraft.nix
    ./miniflux.nix
    ./mosquitto.nix
    ./otel.nix
    ./paperless.nix
    ./postgres.nix
    ./quassel.nix
    ./step-ca.nix
    ./swapfile.nix
    ./tandoor.nix
    ./traefik.nix
    ./vaultwarden.nix
    ./wireguard.nix

    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    srvos.nixosModules.server
    srvos.nixosModules.mixins-systemd-boot
  ];

  age.secrets.id_borgbase.file = ../../secrets/eclipse/id_borgbase.age;
  age.secrets."passwd".file = ../../secrets/common/passwd.age;

  infra.borgbase = {
    enable = true;
    repo = "ssh://c8wl3xsp@c8wl3xsp.repo.borgbase.com/./repo";
    sshKeyFile = config.age.secrets.id_borgbase.path;
  };

  networking = {
    hostName = "eclipse";
    domain = "sefa.cloud";
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;

    firewall = {
      allowedTCPPorts = [
        # terraria
        7777
      ];
      allowedUDPPorts = [
        # jellyfin
        1900
        7359

        # terraria
        7777
      ];
    };
  };

  hardware.graphics.enable = true;

  services.apcupsd = {
    enable = true;
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2500000; # Traefik HTTP3
    "fs.inotify.max_user_instances" = 8192;
  };

  users.users.scrumplex = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys =
      config.users.users.root.openssh.authorizedKeys.keys
      ++ [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCCHT3y+oaFf/ZkKDd8dqwYsgzA8OIViDkeA9vGAHNjyJPoXwnbR2d9p+pI+WW+jIFxIbCz7ho9zUAFRxFkksxA= pass@blackeye"
      ];
    hashedPasswordFile = config.age.secrets."passwd".path;
  };

  system.stateVersion = "23.05";
}

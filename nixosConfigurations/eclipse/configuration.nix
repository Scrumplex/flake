{
  config,
  fpConfig,
  inputs,
  ...
}: let
  inherit (inputs) nixos-facter-modules nixos-hardware srvos;
in {
  imports = [
    ./boot.nix
    ./dyndns.nix
    ./frigate.nix
    ./home-assistant.nix
    ./immich.nix
    ./media
    ./minecraft.nix
    ./miniflux.nix
    ./mosquitto.nix
    ./paperless.nix
    ./postgres.nix
    ./quassel.nix
    ./swapfile.nix
    ./tandoor.nix
    ./traefik.nix
    ./vaultwarden.nix
    ./wireguard.nix

    fpConfig.flake.modules.nixos.physical-server
    fpConfig.flake.modules.nixos.ext-docker

    nixos-facter-modules.nixosModules.facter
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    srvos.nixosModules.server
    srvos.nixosModules.mixins-systemd-boot
  ];

  facter.reportPath = ./facter.json;
  hardware.enableRedistributableFirmware = true;

  age.secrets.id_borgbase.file = ../../secrets/eclipse/id_borgbase.age;

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
    hashedPassword = "$y$j9T$JbosTEvX3uH6.mFV/Sz071$6vVkITFq4INQFdf51.guqaD68JWp6ZcVNGVfPqqIzL/";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ea5c23f6-3b65-45af-8840-a1a6ef68599e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/783B-A3CC";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/26c61352-6e8d-4b09-866f-f7a3c8e7a80c";
    fsType = "ext4";
  };

  boot.initrd.kernelModules = [
    "dm-raid"
    "dm-cache-default"
  ];

  systemd.services.docker.unitConfig.RequiresMountsFor = ["/media"];

  swapDevices = [];

  system.stateVersion = "23.05";
}

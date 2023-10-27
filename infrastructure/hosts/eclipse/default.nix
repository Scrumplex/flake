{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/borg.nix
    ../common/nix.nix
    ../common/nullmailer.nix

    ./boot.nix
    ./dyndns.nix
    ./jellyfin.nix
    ./minecraft.nix
    ./paperless.nix
    ./step-ca.nix
    ./syncthing.nix
    ./transmission.nix
    ./vaultwarden.nix
  ];

  networking = {
    hostName = "eclipse";
    domain = "sefa.cloud";
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;

    firewall = {
      allowedTCPPorts = [
        # k3s
        6443

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

  hardware.opengl.enable = true;

  services.apcupsd = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [
        "--all"
      ];
    };
  };

  services.k3s = {
    enable = true;
    extraFlags = "--disable traefik";
  };
  networking.firewall.trustedInterfaces = ["cni0"];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };
  services.postgresqlBackup.enable = true;

  services.influxdb2.enable = true;

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2500000; # Traefik HTTP3
    "fs.inotify.max_user_instances" = 8192;
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
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCCHT3y+oaFf/ZkKDd8dqwYsgzA8OIViDkeA9vGAHNjyJPoXwnbR2d9p+pI+WW+jIFxIbCz7ho9zUAFRxFkksxA= pass@blackeye"
      ];
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  services.borgbackup.jobs.borgbase = {
    repo = "c8wl3xsp@c8wl3xsp.repo.borgbase.com:repo";
    paths = [config.services.postgresqlBackup.location];
  };

  system.stateVersion = "23.05";
}

{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/common.nix
    ../common/nix.nix
    ../common/nullmailer.nix
    ../common/postgres.nix
    ../common/traefik.nix
    ../common/upgrade.nix

    ./boot.nix
    ./buildbot.nix
    ./dyndns.nix
    ./frigate.nix
    ./harmonia.nix
    ./influx.nix
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
    ./traefik.nix
    ./vaultwarden.nix
    ./wireguard.nix
  ];

  age.secrets."hetzner.key".file = ../../secrets/eclipse/hetzner.key.age;
  age.secrets.id_borgbase.file = ../../secrets/eclipse/id_borgbase.age;

  infra.borgbase = {
    enable = true;
    repo = "ssh://c8wl3xsp@c8wl3xsp.repo.borgbase.com/./repo";
    sshKeyFile = config.age.secrets.id_borgbase.path;
  };

  virtualisation.oci-containers.backend = "docker";

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

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_27;
    autoPrune = {
      enable = true;
      flags = [
        "--all"
      ];
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2500000; # Traefik HTTP3
    "fs.inotify.max_user_instances" = 8192;
  };

  environment.systemPackages = with pkgs; [
    git
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

  system.stateVersion = "23.05";
}

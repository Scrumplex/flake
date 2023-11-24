{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;
in {
  imports = [
    ../common/common.nix
    ../common/borg.nix
    ../common/nix.nix
    ../common/nullmailer.nix
    ../common/traefik.nix

    ./boot.nix
    ./traefik.nix
    ./wireguard.nix
  ];

  networking = {
    hostName = "cosmos";
    domain = "sefa.cloud";
    useDHCP = false;
    interfaces.eth0.useDHCP = true;

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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

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

  services.borgbackup.jobs.borgbase = {
    repo = "gils6l68@gils6l68.repo.borgbase.com:repo";
    encryption.mode = "keyfile-blake2";
  };

  system.stateVersion = "23.05";
}

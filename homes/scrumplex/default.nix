{ config, pkgs, home-manager, ... }: {

  users.users.scrumplex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
  };
  home-manager.users.scrumplex = {
    imports = [ ./home.nix ];

    home.stateVersion = config.system.stateVersion;

    programs.home-manager.enable = true;
    systemd.user.startServices = true;

    nixpkgs.config.allowUnfree = true;
  };
}

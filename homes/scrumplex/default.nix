{ config, pkgs, home-manager, ... }:
let username = "scrumplex";
in {

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "podman" "adbusers" "input" "libvirtd" ];
  };

  nix.settings.trusted-users = [ username ];

  home-manager.users."${username}" = {
    imports = [ ./home.nix ];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.stateVersion = config.system.stateVersion;

    programs.home-manager.enable = true;
    systemd.user.startServices = true;

    nixpkgs.config.allowUnfree = true;
  };
}

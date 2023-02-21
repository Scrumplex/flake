{ lib, config, pkgs, home-manager, ... }:
let
  inherit (lib) optional;
  username = "scrumplex";
  hostName = config.networking.hostName;
in {

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "input" ]
      ++ optional config.networking.networkmanager.enable "networkmanager"
      ++ optional config.programs.adb.enable "adbusers"
      ++ optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ optional config.virtualisation.podman.enable "podman";
  };

  nix.settings.trusted-users = [ username ];

  home-manager.users."${username}" = {
    imports = [ ./common ./${hostName} ];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.stateVersion = config.system.stateVersion;

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

    nixpkgs.config.allowUnfree = true;
  };
}

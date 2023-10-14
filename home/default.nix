username: {
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) optional;
in {
  users.users."${username}" = {
    hashedPassword = "$y$j9T$.xFZ6PXXwF2ntgjscIIiE/$ck86smefjyF1RPhwaYRYf2rWRgpercSVeTBDnMggsr9";

    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups =
      ["wheel" "input" "audio" "video"]
      ++ optional config.security.rtkit.enable "rtkit"
      ++ optional config.networking.networkmanager.enable "networkmanager"
      ++ optional config.programs.adb.enable "adbusers"
      ++ optional config.programs.wireshark.enable "wireshark"
      ++ optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ optional config.virtualisation.podman.enable "podman";
  };

  age.secrets."beets-secrets.yaml" = {
    file = ../secrets/common/beets-secrets.yaml.age;
    owner = username;
  };
  age.secrets."listenbrainz-token" = {
    file = ../secrets/common/listenbrainz-token.age;
    owner = username;
  };

  nix.settings.trusted-users = [username];

  home-manager.users."${username}" = {
    imports = [./roles ./common ./${config.networking.hostName}];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.stateVersion = config.system.stateVersion;

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
  };
}

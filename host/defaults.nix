{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lists) optional;
in {
  roles = {
    base = {
      username = "scrumplex";

      user = {
        hashedPassword = "$y$j9T$.xFZ6PXXwF2ntgjscIIiE/$ck86smefjyF1RPhwaYRYf2rWRgpercSVeTBDnMggsr9";
        # TODO: roles!
        shell = pkgs.fish;
        extraGroups =
          ["audio" "video" "input"]
          ++ optional config.security.rtkit.enable "rtkit"
          ++ optional config.networking.networkmanager.enable "networkmanager"
          ++ optional config.programs.adb.enable "adbusers"
          ++ optional config.programs.wireshark.enable "wireshark"
          ++ optional config.virtualisation.libvirtd.enable "libvirtd"
          ++ optional config.virtualisation.podman.enable "podman";
      };
    };

    firefox.enable = true;
    htop.enable = true;
    mpv.enable = true;
  };
}

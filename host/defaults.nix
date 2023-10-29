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
        extraGroups =
          ["audio" "video" "input"]
          ++ optional config.networking.networkmanager.enable "networkmanager"
          ++ optional config.programs.adb.enable "adbusers"
          ++ optional config.programs.wireshark.enable "wireshark"
          ++ optional config.virtualisation.libvirtd.enable "libvirtd"
          ++ optional config.virtualisation.podman.enable "podman";
      };
    };

    bluetooth.enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
    firefox.enable = true;
    gaming.enable = true;
    htop.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    neovim.enable = true;
    pipewire.enable = true;
    qt.enable = true;
    regional.enable = true;
    shell.enable = true;
    sway = {
      enable = true;
      wallpaper = pkgs.fetchurl {
        name = "sway-wallpaper.jpg";
        url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
        hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
      };
    };
    v4l2loopback.enable = true;
  };
}

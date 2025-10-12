{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib.lists) optional;
in {
  imports = [
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" "scrumplex"])
    (lib.mkAliasOptionModule ["primaryUser"] ["users" "users" "scrumplex"])
  ];

  home-manager.sharedModules = [
    inputs.scrumpkgs.hmModules.waybar-camera-blank
    inputs.scrumpkgs.hmModules.waybar-pa-mute
  ];

  primaryUser.extraGroups =
    optional config.virtualisation.libvirtd.enable "libvirtd"
    ++ optional config.virtualisation.podman.enable "podman";
}

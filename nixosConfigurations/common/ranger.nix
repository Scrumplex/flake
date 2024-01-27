{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) optionalString;
in {
  environment.systemPackages = with pkgs; [ranger];

  hm.xdg.configFile."ranger/rc.conf".text = optionalString config.hm.programs.kitty.enable ''
    set preview_images_method kitty
  '';
}

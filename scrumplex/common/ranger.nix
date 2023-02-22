{ lib, config, pkgs, ... }:

let inherit (lib.strings) optionalString;
in {
  home.packages = with pkgs; [ ranger ];

  xdg.configFile."ranger/rc.conf".text =
    optionalString config.programs.kitty.enable ''
      set preview_images_method kitty
    '';
}

platform: {lib, ...}: let
  inherit (builtins) elem;
  inherit (lib.lists) optionals;
  inherit (lib) platforms;
in {
  imports =
    [
      ./base.nix
      ./htop.nix
      ./mpv.nix
      ./shell.nix
    ]
    ++ optionals (elem platform [platforms.linux]) [
      ./bluetooth.nix
      ./catppuccin.nix
      ./desktop/gtklock.nix
      ./desktop/kitty.nix
      ./desktop/qt
      ./desktop/sway.nix
      ./firefox.nix
      ./gaming.nix
      ./pipewire
      ./regional.nix
      ./v4l2loopback.nix
    ];
}

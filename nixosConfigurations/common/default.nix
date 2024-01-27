{...}: {
  imports = [
    ./beets.nix
    ./bluetooth.nix
    ./boot.nix
    ./desktop
    ./desktop/firefox.nix
    ./desktop/gaming.nix
    ./desktop/gtklock.nix
    ./desktop/image-viewer.nix
    ./desktop/kitty.nix
    ./desktop/pipewire
    ./desktop/qt
    ./desktop/sway
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./home.nix
    ./htop.nix
    ./misc.nix
    ./mpd.nix
    ./mpv.nix
    ./neovim.nix
    ./nix.nix
    ./nvd.nix
    ./pkgs
    ./ranger.nix
    ./regional.nix
    ./utils.nix
    ./v4l2loopback.nix
  ];

  programs.partition-manager.enable = true;
}

{...}: {
  imports = [
    ./beets.nix
    ./bluetooth.nix
    ./boot.nix
    ./desktop
    ./desktop/chromium.nix
    ./desktop/evolution.nix
    ./desktop/firefox.nix
    ./desktop/gaming.nix
    ./desktop/gtk
    ./desktop/gtklock.nix
    ./desktop/image-viewer.nix
    ./desktop/kitty.nix
    ./desktop/nextcloud-client.nix
    ./desktop/obs.nix
    ./desktop/pipewire
    ./desktop/polkit-agent.nix
    ./desktop/qt
    ./desktop/sway
    ./desktop/sway/wob.nix
    ./desktop/vr
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
    ./nix-index.nix
    ./nvd.nix
    ./pkgs
    ./ranger.nix
    ./regional.nix
    ./ssh.nix
    ./syncthing.nix
    ./utils.nix
    ./v4l2loopback.nix
  ];

  programs.partition-manager.enable = true;
}

{inputs, ...}: {
  imports =
    [
      ./beets.nix
      ./bluetooth.nix
      ./boot.nix
      ./desktop
      ./desktop/chromium.nix
      ./desktop/evolution.nix
      ./desktop/firefox.nix
      ./desktop/fuzzel.nix
      ./desktop/gaming.nix
      ./desktop/gtk
      ./desktop/gtklock.nix
      ./desktop/hyprland.nix
      ./desktop/image-viewer.nix
      ./desktop/kitty.nix
      ./desktop/mako.nix
      ./desktop/nextcloud-client.nix
      ./desktop/obs.nix
      ./desktop/pipewire
      ./desktop/polkit-agent.nix
      ./desktop/qt
      ./desktop/screenshot-bash.nix
      ./desktop/swayidle.nix
      ./desktop/vr
      ./desktop/waybar.nix
      ./desktop/wlogout.nix
      ./desktop/wlsunset.nix
      ./desktop/wob.nix
      ./desktop/xwaylandvideobridge.nix
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
      ./password-store.nix
      ./pkgs
      ./ranger.nix
      ./regional.nix
      ./rtl-sdr.nix
      ./ssh.nix
      ./syncthing.nix
      ./utils.nix
      ./v4l2loopback.nix

      inputs.agenix.nixosModules.age
    ]
    ++ builtins.attrValues inputs.scrumpkgs.nixosModules;

  nixpkgs.overlays = [
    inputs.scrumpkgs.overlays.default
  ];

  programs.partition-manager.enable = true;
}

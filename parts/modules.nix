{
  flake = {
    hmModules = {
      catppuccin = import ../modules/hm/catppuccin.nix;
      fish-theme = import ../modules/hm/fish-theme.nix;
      jellyfin-mpv-shim = import ../modules/hm/jellyfin-mpv-shim.nix;
      pipewire = import ../modules/hm/pipewire.nix;
      waybar-camera-blank = import ../modules/hm/waybar/camera-blank.nix;
      waybar-pa-mute = import ../modules/hm/waybar/pa-mute.nix;
    };
    nixosModules = {
      flatpak-icons-workaround = import ../modules/nixos/flatpak-icons-workaround.nix;
      monado = import ../modules/nixos/monado.nix;
    };
  };
}

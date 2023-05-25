{
  flake = {
    hmModules = {
      catppuccin = import ../modules/hm/catppuccin.nix;
      fish-theme = import ../modules/hm/fish-theme.nix;
      jellyfin-mpv-shim = import ../modules/hm/jellyfin-mpv-shim.nix;
      pipewire = import ../modules/hm/pipewire.nix;
    };
    nixosModules = {
      flatpak-icons-workaround = import ../modules/nixos/flatpak-icons-workaround.nix;
    };
  };
}

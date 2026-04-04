{
  fpConfig,
  pkgs,
  ...
}: {
  imports = [
    ./audiobookshelf.nix
    ./jellyfin.nix
    ./sabnzbd.nix
    ./servarr.nix
    ./slskd.nix
    ./syncthing.nix
    ./transmission.nix
    fpConfig.flake.modules.nixos."ext-media"
  ];

  environment.systemPackages = with pkgs; [
    ffmpeg
  ];
}

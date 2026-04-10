{
  flake.modules.nixos."machine-fornax" = {pkgs, ...}: {
    environment.systemPackages = [pkgs.jellyfin-desktop];
  };
}

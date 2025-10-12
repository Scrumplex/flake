{
  flake.modules.nixos.base = {pkgs, ...}: {
    documentation.man = {
      enable = true;
      man-db.enable = true;
    };

    environment.systemPackages = [pkgs.man-pages];
  };
}

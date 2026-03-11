{
  flake.modules.nixos."gaming" = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.r2modman
    ];
  };
}

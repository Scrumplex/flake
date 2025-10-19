{
  flake.modules.nixos.raspberry-pi-4 = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      iw
      ethtool
    ];
  };
}

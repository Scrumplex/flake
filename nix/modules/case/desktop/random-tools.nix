{...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    nixpkgs.allowedUnfreePackageNames = ["anydesk"];

    environment.systemPackages = with pkgs; [
      anydesk
    ];
  };
}

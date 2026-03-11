{inputs, ...}: {
  flake.modules.nixos.gaming = {pkgs, ...}: {
    imports = [
      inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    ];

    programs.steam.extraCompatPackages = [
      pkgs.proton-ge-rtsp-bin
    ];
  };
}

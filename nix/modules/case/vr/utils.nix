{
  flake.modules.nixos.vr = {
    inputs,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.bs-manager
      index_camera_passthrough
      wayvr-dashboard
      wlx-overlay-s
    ];
  };
}

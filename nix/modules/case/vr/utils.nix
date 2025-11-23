{
  flake.modules.nixos.vr = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bs-manager
      index_camera_passthrough
      wayvr-dashboard
      wlx-overlay-s
    ];
  };
}

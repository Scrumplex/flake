{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services.udev.packages = with pkgs; [meletrix-udev-rules];
  };
}

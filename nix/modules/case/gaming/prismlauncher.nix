{inputs, ...}: {
  flake.modules.nixos.gaming = {pkgs, ...}: {
    nixpkgs.overlays = [
      inputs.prismlauncher.overlays.default
    ];

    environment.systemPackages = with pkgs; [
      prismlauncher
    ];
  };
}

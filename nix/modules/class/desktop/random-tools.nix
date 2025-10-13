{...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      anydesk
      kdePackages.kdenlive
    ];
  };
}

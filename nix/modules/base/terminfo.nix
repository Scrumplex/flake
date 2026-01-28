{...}: {
  flake.modules.nixos."base" = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kitty.terminfo
    ];
  };
}

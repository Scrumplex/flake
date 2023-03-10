{pkgs, ...}: {
  imports = [./borg.nix ./dev.nix];

  home.packages = with pkgs; [discord];
}

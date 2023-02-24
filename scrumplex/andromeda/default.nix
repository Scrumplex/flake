{pkgs, ...}: {
  imports = [./borg.nix];

  home.packages = with pkgs; [discord];
}

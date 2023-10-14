{...}: {
  imports = [./dev.nix ./sway];

  roles.firefox.enable = true;
}

{...}: {
  imports = [
    ./autostart.nix
    ./dev.nix
    ./screenshot-bash.nix
    ./sway
  ];

  theme = {
    enable = true;
    palette = "mocha";
  };
}

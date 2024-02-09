{...}: {
  imports = [
    ./autostart.nix
    ./dev.nix
  ];

  theme = {
    enable = true;
    palette = "mocha";
  };
}

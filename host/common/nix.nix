{inputs, ...}: let
  channelPath = "/etc/nix/channels/nixpkgs";
in {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "repl-flake" "no-url-literals"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["root"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
      persistent = true;
    };
    nixPath = [
      "nixpkgs=${channelPath}"
    ];
    registry.n.flake = inputs.nixpkgs;
  };

  systemd.tmpfiles.rules = [
    "L+ ${channelPath}     - - - - ${inputs.nixpkgs.outPath}"
  ];
}

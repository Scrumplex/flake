{inputs, ...}: let
  channelPath = "/etc/nix/channels/nixpkgs";
in {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "repl-flake" "no-url-literals"];
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

{pkgs, ...}: let
  channelPath = "/etc/nix/channels/nixpkgs";
in {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nixPath = [
      "nixpkgs=${channelPath}"
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ ${channelPath}     - - - - ${pkgs.path}"
  ];
}

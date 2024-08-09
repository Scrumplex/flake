{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption optionals;

  cfg = config.profile.nix;

  channelPath = "/etc/nix/channels/nixpkgs";
in {
  options.profile.nix.enableMyCache = mkEnableOption "cache.sefa.cloud cache";
  config = {
    nix = {
      package = pkgs.lix;
      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
      daemonIOSchedPriority = 6;
      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes" "repl-flake" "no-url-literals"];
        substituters =
          (optionals cfg.enableMyCache [
            "https://cache.sefa.cloud"
          ])
          ++ [
            "https://cache.nixos.org"
            "https://cache.garnix.io"
            "https://nix-community.cachix.org"
            "https://nixpkgs-wayland.cachix.org"
          ];
        trusted-public-keys =
          (optionals cfg.enableMyCache [
            "cache.sefa.cloud-1:Mxw+jeVRlZ4yJVGP+az80RjlUEqCUlX+M7vwGAq9drA="
          ])
          ++ [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
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
  };
}

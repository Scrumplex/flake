{inputs, ...}: let
  channelPath = "/etc/nix/channels/nixpkgs";
in {
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 6;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "no-url-literals"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://prismlauncher.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
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

  systemd.tmpfiles.settings."10-nixpkgs".${channelPath}."L+".argument = inputs.nixpkgs.outPath;
}

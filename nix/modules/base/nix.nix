{inputs, ...}: let
  channelPath = "/etc/nix/channels/nixpkgs";
in {
  flake.modules.nixos.base = {...}: {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
    ];

    programs.command-not-found.enable = false;
    programs.nix-index-database.comma.enable = true;

    nix = {
      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
      daemonIOSchedPriority = 6;
      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes" "no-url-literals"];
        substituters = [
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        trusted-users = ["root"];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
        persistent = true;
      };
      nixPath = [
        "nixpkgs=${channelPath}"
      ];
      registry.n.flake = inputs.nixpkgs;
    };

    systemd.tmpfiles.settings."10-nixpkgs".${channelPath}."L+".argument = inputs.nixpkgs.outPath;
  };
}

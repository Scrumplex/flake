{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    nixpkgs.allowedUnfreePackageNames = ["steam" "steam-unwrapped"];

    programs.steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    environment.systemPackages = [
      pkgs.protontricks
    ];
  };
}

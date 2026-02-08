{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    nixpkgs.allowedUnfreePackageNames = ["steam" "steam-unwrapped"];
    programs.steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-ge-rtsp-bin
      ];
    };
  };
}

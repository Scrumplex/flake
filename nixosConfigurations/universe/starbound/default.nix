{
  lib,
  pkgs,
  ...
}: let
  starbound-server = pkgs.callPackage ./server.nix {};
in {
  nixpkgs.allowedUnfreePackageNames = ["starbound-dedicated-server" "Starbound.tar"];

  systemd.services."starbound-dedicated-server" = {
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    script = ''
      cd "$STATE_DIRECTORY"
      exec ${lib.getExe starbound-server} -bootconfig ${starbound-server}/share/starbound/sbinit.config
    '';
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "starbound-dedicated-server";
    };
  };

  networking.firewall.allowedTCPPorts = [21025];
}

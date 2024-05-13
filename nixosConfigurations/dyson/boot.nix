{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [sbctl];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}

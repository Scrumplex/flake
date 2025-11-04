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
      configurationLimit = 4;
      pkiBundle = "/etc/secureboot";
    };
  };
}

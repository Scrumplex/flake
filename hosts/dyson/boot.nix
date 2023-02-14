{ lib, pkgs, ... }: {
  boot.bootspec.enable = lib.mkForce true;
  environment.systemPackages = with pkgs; [ sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.plymouth = {
    enable = true;
    theme = "bgrt";
    font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
  };
}

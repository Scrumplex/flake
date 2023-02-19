{ lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ sbctl ];

  boot = {
    bootspec.enable = lib.mkForce true;

    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    plymouth = {
      enable = true;
      theme = "bgrt";
      font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
    };

    initrd.systemd.enable = true;
  };
}

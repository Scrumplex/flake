{
  lib,
  pkgs,
  ...
}: {
  boot.plymouth = {
    enable = lib.mkDefault true;
    theme = "bgrt";
    font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
  };

  specialisation."verbose".configuration = {
    boot.plymouth.enable = false;
  };
}

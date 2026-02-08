{lib, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: let
    wallpaper = pkgs.fetchurl {
      name = "sway-wallpaper.jpg";
      url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
      hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
    };
  in {
    systemd.user.services."swaybg" = {
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      requisite = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${wallpaper}";
        Restart = "on-failure";
      };
    };
  };
}

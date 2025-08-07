{
  lib,
  pkgs,
  ...
}: let
  wallpaper = pkgs.fetchurl {
    name = "sway-wallpaper.jpg";
    url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
    hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
  };
in {
  programs.niri.enable = true;
  hm.xdg.configFile."niri/config.kdl".source = ./niri.kdl;

  environment.systemPackages = with pkgs; [xwayland-satellite mpc brightnessctl pamixer];

  hm.programs.fish.interactiveShellInit = lib.mkOrder 2000 ''
    test -n "$XDG_SESSION_TYPE" -a "$XDG_SESSION_TYPE" = "tty" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq 1; and begin
      exec systemd-cat -t niri-startup niri-session
    end
  '';

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
}

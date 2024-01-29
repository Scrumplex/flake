{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./fuzzel.nix ./mako.nix ./swayidle.nix ./waybar ./wlogout.nix ./wlsunset.nix];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  wayland.windowManager.sway = {
    config.colors = with config.theme.colors; {
      focused = {
        background = "#${blue}";
        border = "#${blue}";
        childBorder = "#${blue}";
        indicator = "#${blue}";
        text = "#${base}";
      };
      focusedInactive = {
        background = "#${surface0}";
        border = "#${surface0}";
        childBorder = "#${surface0}";
        indicator = "#${surface0}";
        text = "#${pink}";
      };
      unfocused = {
        background = "#${base}";
        border = "#${base}";
        childBorder = "#${base}";
        indicator = "#${base}";
        text = "#${text}";
      };
      urgent = {
        background = "#${peach}";
        border = "#${peach}";
        childBorder = "#${peach}";
        indicator = "#${peach}";
        text = "#${base}";
      };
    };
  };

  home.packages = with pkgs; [wl-clipboard pulsemixer];

  programs.fish.interactiveShellInit = lib.mkOrder 2000 ''
    test -n "$XDG_SESSION_TYPE" -a "$XDG_SESSION_TYPE" = "tty" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq 1; and begin
        sway
    end
  '';
}

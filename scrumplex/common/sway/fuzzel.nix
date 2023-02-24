{ pkgs, ... }:

{
  home.packages = with pkgs; [ fuzzel ];

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font="Monocraft:size=13"
    terminal=${pkgs.kitty}/bin/kitty

    [colors]
    # surface0
    background=313244ff
    # text
    text=cdd6f4ff
    # blue
    match=89b4faff
    # peach
    selection=fab387ff
    # base
    selection-text=1e1e2eff
    # peach
    border=fab387ff

    [border]
    width=2
    radius=12
  '';
  programs.password-store.package =
    pkgs.pass-wayland.override { dmenu-wayland = pkgs.fuzzel-dmenu-shim; };
}

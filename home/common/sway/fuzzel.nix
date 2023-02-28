{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [fuzzel];

  xdg.configFile."fuzzel/fuzzel.ini".text = with config.theme; ''
    [main]
    font="Monocraft:size=13"
    terminal=${pkgs.kitty}/bin/kitty

    [colors]
    background=${surface0}ff
    text=${text}ff
    match=${blue}ff
    selection=${peach}ff
    selection-text=${base}ff
    border=${peach}ff

    [border]
    width=2
    radius=12
  '';
  programs.password-store.package =
    pkgs.pass-wayland.override {dmenu-wayland = pkgs.fuzzel-dmenu-shim;};
}

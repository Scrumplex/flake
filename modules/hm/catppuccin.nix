{
  config,
  lib,
  ...
}: let
  inherit (builtins) substring;
  inherit (lib) types;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.strings) toUpper;

  cfg = config.theme;

  mkColorOption = name:
    mkOption {
      type = types.str;
      visible = true;
      readOnly = true;
      description = "hex color code for ${name}";
    };

  colorOpts = types.submodule {
    options = {
      rosewater = mkColorOption "rosewater";
      flamingo = mkColorOption "flamingo";
      pink = mkColorOption "pink";
      mauve = mkColorOption "mauve";
      red = mkColorOption "red";
      maroon = mkColorOption "maroon";
      peach = mkColorOption "peach";
      yellow = mkColorOption "yellow";
      green = mkColorOption "green";
      teal = mkColorOption "teal";
      sky = mkColorOption "sky";
      sapphire = mkColorOption "sapphire";
      blue = mkColorOption "blue";
      lavender = mkColorOption "lavender";
      text = mkColorOption "text";
      subtext1 = mkColorOption "subtext1";
      subtext0 = mkColorOption "subtext0";
      overlay2 = mkColorOption "overlay2";
      overlay1 = mkColorOption "overlay1";
      overlay0 = mkColorOption "overlay0";
      surface2 = mkColorOption "surface2";
      surface1 = mkColorOption "surface1";
      surface0 = mkColorOption "surface0";
      base = mkColorOption "base";
      mantle = mkColorOption "mantle";
      crust = mkColorOption "crust";
    };
  };

  latteColors = {
    rosewater = "dc8a78";
    flamingo = "dd7878";
    pink = "ea76cb";
    mauve = "8839ef";
    red = "d20f39";
    maroon = "e64553";
    peach = "fe640b";
    yellow = "df8e1d";
    green = "40a02b";
    teal = "179299";
    sky = "04a5e5";
    sapphire = "209fb5";
    blue = "1e66f5";
    lavender = "7287fd";
    text = "4c4f69";
    subtext1 = "5c5f77";
    subtext0 = "6c6f85";
    overlay2 = "7c7f93";
    overlay1 = "8c8fa1";
    overlay0 = "9ca0b0";
    surface2 = "acb0be";
    surface1 = "bcc0cc";
    surface0 = "ccd0da";
    base = "eff1f5";
    mantle = "e6e9ef";
    crust = "dce0e8";
  };

  frappeColors = {
    rosewater = "dc8a78";
    flamingo = "dd7878";
    pink = "ea76cb";
    mauve = "8839ef";
    red = "d20f39";
    maroon = "e64553";
    peach = "fe640b";
    yellow = "df8e1d";
    green = "40a02b";
    teal = "179299";
    sky = "04a5e5";
    sapphire = "209fb5";
    blue = "1e66f5";
    lavender = "7287fd";
    text = "4c4f69";
    subtext1 = "5c5f77";
    subtext0 = "6c6f85";
    overlay2 = "7c7f93";
    overlay1 = "8c8fa1";
    overlay0 = "9ca0b0";
    surface2 = "acb0be";
    surface1 = "bcc0cc";
    surface0 = "ccd0da";
    base = "eff1f5";
    mantle = "e6e9ef";
    crust = "dce0e8";
  };

  macchiatoColors = {
    rosewater = "f4dbd6";
    flamingo = "f0c6c6";
    pink = "f5bde6";
    mauve = "c6a0f6";
    red = "ed8796";
    maroon = "ee99a0";
    peach = "f5a97f";
    yellow = "eed49f";
    green = "a6da95";
    teal = "8bd5ca";
    sky = "91d7e3";
    sapphire = "7dc4e4";
    blue = "8aadf4";
    lavender = "b7bdf8";
    text = "cad3f5";
    subtext1 = "b8c0e0";
    subtext0 = "a5adcb";
    overlay2 = "939ab7";
    overlay1 = "8087a2";
    overlay0 = "6e738d";
    surface2 = "5b6078";
    surface1 = "494d64";
    surface0 = "363a4f";
    base = "24273a";
    mantle = "1e2030";
    crust = "181926";
  };

  mochaColors = {
    rosewater = "f5e0dc";
    flamingo = "f2cdcd";
    pink = "f5c2e7";
    mauve = "cba6f7";
    red = "f38ba8";
    maroon = "eba0ac";
    peach = "fab387";
    yellow = "f9e2af";
    green = "a6e3a1";
    teal = "94e2d5";
    sky = "89dceb";
    sapphire = "74c7ec";
    blue = "89b4fa";
    lavender = "b4befe";
    text = "cdd6f4";
    subtext1 = "bac2de";
    subtext0 = "a6adc8";
    overlay2 = "9399b2";
    overlay1 = "7f849c";
    overlay0 = "6c7086";
    surface2 = "585b70";
    surface1 = "45475a";
    surface0 = "313244";
    base = "1e1e2e";
    mantle = "181825";
    crust = "11111b";
  };
in {
  options.theme = {
    enable = mkEnableOption "theme";

    palette = mkOption {
      type = types.str;
      default = "mocha";
    };

    variant = mkOption {
      type = types.str;
      default = "teal";
    };

    colors = mkOption {
      type = colorOpts;
      visible = true;
      readOnly = true;
      description = "Definition of theme colors";
    };

    gtk = mkEnableOption "apply GTK theme";
    kitty = mkEnableOption "apply Kitty theme";
  };

  config = let
    themeColors =
      if cfg.palette == "latte"
      then latteColors
      else if cfg.palette == "frappe"
      then frappeColors
      else if cfg.palette == "macchiato"
      then macchiatoColors
      else mochaColors;

    paletteUpper = toUpper (substring 0 1 cfg.palette) + (substring 1 999 cfg.palette);
  in
    mkIf cfg.enable (mkMerge [
      {
        theme.colors = themeColors;
      }
      (mkIf cfg.kitty {
        programs.kitty.theme = "Catppuccin-${paletteUpper}";
      })
    ]);
}

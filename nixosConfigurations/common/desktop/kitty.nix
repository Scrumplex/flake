{
  config,
  lib,
  ...
}: let
  staticBinPath = "/etc/nix/programs/kitty";
in {
  hm.programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    # TODO: font role
    font.name = "Fira Code";
    settings = {
      disable_ligatures = "cursor";
      paste_actions = "quote-urls-at-prompt";
      placement_strategy = "top-left";
      tab_bar_style = "powerline";
      background_opacity = "0.975";
      update_check_interval = 0;
    };
    shellIntegration.mode = "no-cursor";
    # TODO: nerd-fonts role
    extraConfig = ''
      # From https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
      # Seti-UI + Custom
      symbol_map U+e5fa-U+e62c Symbols Nerd Font
      # Devicons
      symbol_map U+e700-U+e7c5 Symbols Nerd Font
      # Font Awesome
      symbol_map U+f000-U+f2e0 Symbols Nerd Font
      # Font Awesome Extension
      symbol_map U+e200-U+e2a9 Symbols Nerd Font
      # Material Design Icons
      symbol_map U+f0001-U+f1af0 Symbols Nerd Font
      # Weather
      symbol_map U+e300-U+e3e3 Symbols Nerd Font
      # Octicons
      symbol_map U+f400-U+f532,U+2665,U+26a1 Symbols Nerd Font
      # Powerline Symbols
      symbol_map U+e0a0-U+e0a2,U+e0b0-U+e0b3 Symbols Nerd Font
      # Powerline Extra Symbols
      symbol_map U+e0a3,U+e0b4-U+e0c8,U+e0ca,U+e0cc-U+e0d4 Symbols Nerd Font
      # IEC Power Symbols
      symbol_map U+23fb-U+23fe,U+eb58 Symbols Nerd Font
      # Font Logos (Formerly Font Linux)
      symbol_map U+f300-U+f32f Symbols Nerd Font
      # Pomicons
      symbol_map U+e000-U+e00a Symbols Nerd Font
      # Codicons
      symbol_map U+ea60-U+ebeb Symbols Nerd Font
      # Heavy Angle Brackets
      symbol_map U+e276c-U+e2771 Symbols Nerd Font
      # Box Drawing
      symbol_map U+2500-U+259f Symbols Nerd Font
    '';
  };

  # Set xdg-terminal-exec target
  xdg.terminal-exec.enable = lib.mkDefault true;
  hm.xdg.configFile."xdg-terminals.list".text = ''
    kitty.desktop
  '';

  systemd.tmpfiles.settings."10-kitty".${staticBinPath}."L+".argument = lib.getExe config.hm.programs.kitty.package;

  environment.sessionVariables."TERMINAL" = staticBinPath;
}

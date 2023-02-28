{...}: {
  programs.kitty = {
    enable = true;
    font.name = "Fira Code";
    settings = {
      disable_ligatures = "cursor";
      paste_actions = ""; # removes all actions
      placement_strategy = "top-left";
      tab_bar_style = "powerline";
      background_opacity = "0.975";
      update_check_interval = 0;
    };
    extraConfig = ''
      # Seti-UI + Custom
      symbol_map U+e5fa-U+e62b Symbols Nerd Font
      # Devicons
      symbol_map U+e700-U+e7c5 Symbols Nerd Font
      # Font Awesome
      symbol_map U+f000-U+f2e0 Symbols Nerd Font
      # Font Awesome Extension
      symbol_map U+e200-U+e2a9 Symbols Nerd Font
      # Material Design Icons
      symbol_map U+f500-U+fd46 Symbols Nerd Font
      # Weather
      symbol_map U+e300-U+e3eb Symbols Nerd Font
      # Octicons
      symbol_map U+f400-U+f4a8,U+2665,U+26a1,U+f27c Symbols Nerd Font
      # Powerline Extra Symbols
      symbol_map U+e0a3,U+e0b4-U+e0c8,U+e0ca,U+e0cc-U+e0d2,U+e0d4 Symbols Nerd Font
      # IEC Power Symbols
      symbol_map U+23fb-U+23fe,U+eb58 Symbols Nerd Font
      # Font Logos (Formerly Font Linux)
      symbol_map U+f300-U+f313 Symbols Nerd Font
      # Pomicons
      symbol_map U+e000-U+e00d Symbols Nerd Font

      # QWERTZ moment
      map kitty_mod+y scroll_to_prompt -1
    '';
  };

  theme.kitty = true;
}

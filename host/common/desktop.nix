{
  lib,
  pkgs,
  ...
}: {
  programs.sway.enable = true;
  security.pam.services.gtklock = {};

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      fira
      monocraft
      fira-code
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
      roboto
    ];

    enableDefaultPackages = true;

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        sansSerif = ["Fira Sans"];
        monospace = ["Fira Code"];
      };

      localConf = let
        fonts = [
          "Fira Code"
          "Fira Code,Fira Code Light"
          "Fira Code,Fira Code Medium"
          "Fira Code,Fira Code Retina"
          "Fira Code,Fira Code SemiBold"
          "Monocraft"
        ];

        mkAlias = font: ''
          <alias>
            <family>${font}</family>
            <prefer><family>Symbols Nerd Font</family></prefer>
          </alias>
        '';

        aliases = builtins.map mkAlias fonts;
        aliases' = lib.strings.concatLines aliases;
      in ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          ${aliases'}
        </fontconfig>
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.systemPackages = with pkgs; [
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
  ];
}

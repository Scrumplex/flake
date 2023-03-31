{pkgs, ...}: {
  programs.sway.enable = true;
  security.pam.services.gtklock = {};

  fonts = {
    fonts = with pkgs; [
      noto-fonts-cjk-sans
      fira
      monocraft
      fira-code
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    enableDefaultFonts = true;

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

      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <alias>
            <family>Fira Code</family>
            <prefer><family>Symbols Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>Fira Code,Fira Code Medium</family>
            <prefer><family>Symbols Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>Fira Code,Fira Code SemiBold</family>
            <prefer><family>Symbols Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>Fira Code,Fira Code Light</family>
            <prefer><family>Symbols Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>Fira Code,Fira Code Retina</family>
            <prefer><family>Symbols Nerd Font</family></prefer>
          </alias>
          <alias>
            <family>Monocraft</family>
            <prefer><family>Symbols Nerd Font</family></prefer>
          </alias>
        </fontconfig>
      '';
    };
  };
}

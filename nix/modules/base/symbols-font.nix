{lib, ...}: {
  flake.modules.nixos."base" = {
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types;
    inherit (lib.modules) mkIf;
    inherit (lib.options) literalExpression mkEnableOption mkOption;

    cfg = config.fonts.symbols;
  in {
    options.fonts.symbols = {
      enable = mkEnableOption "font symbols";

      package = mkOption {
        default = pkgs.nerd-fonts.symbols-only;
        defaultText = literalExpression ''
          pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];}
        '';
        description = ''
          Font package that contains symbols font
        '';
        type = types.package;
      };

      symbolsFamily = mkOption {
        default = "Symbols Nerd Font";
        description = ''
          Font family name of symbols font
        '';
        example = "PowerlineSymbols";
        type = types.str;
      };

      fonts = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["Fira Code" "Fira Code,Fira Code Light"];
        description = ''
          Fonts to enable Nerd Fonts symbols for.
        '';
      };
    };

    config = let
      mkAlias = font: ''
        <alias>
          <family>${font}</family>
          <prefer><family>${cfg.symbolsFamily}</family></prefer>
        </alias>
      '';

      aliases = map mkAlias cfg.fonts;
      aliases' = lib.strings.concatLines aliases;
    in
      mkIf cfg.enable {
        fonts = {
          packages = [
            cfg.package
          ];

          fontconfig.localConf = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
            <fontconfig>
              ${aliases'}
            </fontconfig>
          '';
        };
      };
  };
}

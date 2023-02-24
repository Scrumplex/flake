{
  config,
  lib,
  ...
}: let
  inherit (lib) types literalExpression;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.programs.fish.theme;
in {
  options.programs.fish.theme = with types; {
    enable = mkEnableOption "theme";

    name = mkOption {
      type = str;
      default = null;
      example = "Catppuccin Mocha";
    };

    plugin = mkOption {
      type = package;
      default = null;
      example = literalExpression ''
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "b90966686068b5ebc9f80e5b90fdf8c02ee7a0ba";
          sha256 = "wQlYQyqklU/79K2OXRZXg5LvuIugK7vhHgpahpLFaOw=";
        }
      '';
    };
  };
  config = mkIf cfg.enable {
    programs.fish.shellInit = ''
      fish_config theme choose "${cfg.name}"
    '';
    xdg.configFile."fish/themes/${cfg.name}.theme".source = "${cfg.plugin}/themes/${cfg.name}.theme";
  };
}

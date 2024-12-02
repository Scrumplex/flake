{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles.shell;
in {
  options.roles.shell = {
    enable = mkEnableOption "shell role";
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    roles.base.user.shell = pkgs.fish;

    hm = {
      home.packages = with pkgs; [
        file
        libqalculate
        parallel
        fzf
        ripgrep
        tree
      ];
      programs.fish = {
        enable = true;
        shellInit = ''
          set -g theme_color_scheme "catppuccin"
          set -g theme_nerd_fonts "yes"
          set -g theme_title_display_process "yes"
        '';

        shellAliases = lib.mkMerge [
          {
            ip = "ip --color=auto";
            ll = "ls --long --all --classify=always";
            ls = "eza"; # note: we rely on the alias created by eza
          }
        ];
        functions.systemctl = ''
          if contains -- --user $argv
              command systemctl $argv
          else
              sudo systemctl $argv
          end
        '';
        plugins = with pkgs.fishPlugins; [
          {
            name = "autopair.fish";
            inherit (autopair-fish) src;
          }
          {
            name = "bobthefisher";
            inherit (bobthefisher) src;
          }
          {
            name = "fzf";
            inherit (fzf) src;
          }
          {
            name = "humantime.fish";
            inherit (humantime-fish) src;
          }
          {
            name = "puffer";
            inherit (puffer) src;
          }
          {
            name = "z";
            inherit (z) src;
          }
        ];
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.eza = {
        enable = true;
        icons = "auto";
      };
    };
  };
}

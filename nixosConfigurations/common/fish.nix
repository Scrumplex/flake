{
  lib,
  pkgs,
  ...
}: {
  programs.fish.enable = true;
  primaryUser.shell = pkgs.fish;

  hm = {
    home.packages = with pkgs; [
      file
      libqalculate
      parallel
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
          ll = "ls -laFh";
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
      catppuccin.enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.eza = {
      enable = true;
      icons = true;
    };
  };
}

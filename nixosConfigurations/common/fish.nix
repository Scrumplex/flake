{
  lib,
  pkgs,
  ...
}: {
  programs.fish.enable = true;
  primaryUser.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    fd
    file
    libqalculate
    parallel
    ripgrep
    tree
  ];

  hm = {
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
          ll = "ls --long --all --classify";
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
      icons = "auto";

      # We have custom ll and ls aliases
      enableFishIntegration = false;

      extraOptions = [
        "--group"
        "--smart-group"
      ];
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = false; # we use jethrokuan/fzf instead
      defaultOptions = [
        "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
      ];
    };
  };
}

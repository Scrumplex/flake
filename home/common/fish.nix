{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # we use jethrokuan/fzf instead
    defaultOptions = [
      "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
    ];
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set -g theme_color_scheme "catppuccin"
      set -g theme_nerd_fonts "yes"
      set -g theme_title_display_process "yes"
    '';
    shellAbbrs = {
      g = "git";
      ga = "git add";
      gap = "git add -p";
      gca = "git commit -s --amend";
      gcm = "git commit -sm";
      gco = "git checkout";
      gd = "git diff";
      gdc = "git diff --cached";
      gl = "git log";
      gp = "git push";
      gpl = "git pull";
      gri = "git rebase --interactive";
      grc = "git rebase --continue";
      gs = "git status";
    };
    shellAliases = lib.mkMerge [
      {
        ll = "ls -laFh";
      }
      (lib.mkIf config.programs.exa.enable {
        ls = "exa"; # note: we rely on the alias created by exa
      })
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
        src = autopair-fish.src;
      }
      {
        name = "bobthefisher";
        src = bobthefisher.src;
      }
      {
        name = "fzf";
        src = fzf.src;
      }
      {
        name = "humantime.fish";
        src = humantime-fish.src;
      }
      {
        name = "puffer";
        src = puffer.src;
      }
      {
        name = "z";
        src = z.src;
      }
    ];
    theme = {
      enable = true;
      name = "Catppuccin Mocha";
      plugin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "b90966686068b5ebc9f80e5b90fdf8c02ee7a0ba";
        sha256 = "wQlYQyqklU/79K2OXRZXg5LvuIugK7vhHgpahpLFaOw=";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.exa = {
    enable = true;
    icons = true;
    git = true;
  };
}

{
  config,
  inputs,
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
        ip = "ip --color=auto";
        ll = "ls -laFh";
      }
      (lib.mkIf config.programs.eza.enable {
        ls = "eza"; # note: we rely on the alias created by eza
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
      plugin = inputs.catppuccin-fish;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };
}

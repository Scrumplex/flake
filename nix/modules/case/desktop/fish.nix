{config, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    programs.fish = {
      enable = true;
      package = pkgs.fish;
    };
    users.users.${config.flake.meta.username}.shell = pkgs.fish;
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    catppuccin.eza.enable = true;
    catppuccin.fish.enable = true;
    catppuccin.fzf.enable = true;

    programs.bash.enable = true;
    programs.fish = {
      enable = true;
      package = pkgs.fish;

      shellInit = ''
        set -g theme_color_scheme "catppuccin"
        set -g theme_nerd_fonts "yes"
        set -g theme_title_display_process "yes"
      '';

      shellAliases = {
        ip = "ip --color=auto";
        ll = "ls --long --all --classify";
        ls = "eza"; # note: we rely on the alias created by eza
      };

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
    };
  };
}

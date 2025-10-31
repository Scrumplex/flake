{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git-extras
    glab
  ];

  hm = {
    catppuccin.delta.enable = true;

    programs.mergiraf.enable = true;

    programs.fish.shellAbbrs = {
      g = "git";
      ga = "git add";
      gap = "git add -p";
      gca = "git commit -s --amend";
      gcf = "git commit -s --fixup";
      gcm = "git commit -sm";
      gco = "git checkout";
      gd = "git diff";
      gdc = "git diff --cached";
      gl = "git log";
      gp = "git push";
      gpl = "git pull";
      gr = "git rebase";
      gra = "git rebase --autosquash";
      gri = "git rebase --interactive";
      grc = "git rebase --continue";
      gs = "git status";
    };

    programs.gh = {
      enable = true;
      settings = {
        # Workaround for https://github.com/nix-community/home-manager/issues/4744
        version = "1";
        git_protocol = "ssh";
      };
    };

    programs.git = {
      enable = true;
      package = pkgs.gitFull;

      lfs.enable = true;

      signing.key = null;

      settings = {
        alias.unpushed = "log --branches --not --remotes --no-walk --decorate --oneline";
        user = {
          name = "Sefa Eyeoglu";
          email = "contact@scrumplex.net";
        };
        core.autocrlf = "input";
        color.ui = "auto";
        diff.colorMoved = "default";
        push.followTags = true;
        pull.rebase = true;
        init.defaultBranch = "main";

        # Thanks Scott! https://www.youtube.com/watch?v=aolI_Rz0ZqY
        rerere.enabled = true;
        core.fsmonitor = true;

        url = {
          "https://github.com/".insteadOf = "github:";
          "ssh://git@github.com/".pushInsteadOf = "github:";
          "https://gitlab.com/".insteadOf = "gitlab:";
          "ssh://git@gitlab.com/".pushInsteadOf = "gitlab:";
          "https://aur.archlinux.org/".insteadOf = "aur:";
          "ssh://aur@aur.archlinux.org/".pushInsteadOf = "aur:";
          "https://git.sr.ht/".insteadOf = "srht:";
          "ssh://git@git.sr.ht/".pushInsteadOf = "srht:";
          "https://codeberg.org/".insteadOf = "codeberg:";
          "ssh://git@codeberg.org/".pushInsteadOf = "codeberg:";
        };

        # Replace the default set by programs.git.signing.signByDefault
        tag.gpgSign = false;
      };
    };

    programs.delta = {
      enable = true;
      options.navigate = true;
    };

    programs.eza.git = true;
  };
}

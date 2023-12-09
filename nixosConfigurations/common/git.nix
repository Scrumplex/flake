{pkgs, ...}: {
  hm = {
    home.packages = with pkgs; [git-extras];

    programs.fish.shellAbbrs = {
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

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      userName = "Sefa Eyeoglu";
      userEmail = "contact@scrumplex.net";

      delta = {
        enable = true;
        options.navigate = true;
      };

      signing.key = null;

      extraConfig = {
        core.autocrlf = "input";
        color.ui = "auto";
        diff.colorMoved = "default";
        push.followTags = true;
        pull.rebase = true;
        init.defaultBranch = "main";
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
  };
}

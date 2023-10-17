{...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # we use jethrokuan/fzf instead
    defaultOptions = [
      "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
    ];
  };

  programs.fish = {
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
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza.git = true;
}

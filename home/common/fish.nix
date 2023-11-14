{...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = false; # we use jethrokuan/fzf instead
    defaultOptions = [
      "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
    ];
  };

  programs.eza.git = true;
}

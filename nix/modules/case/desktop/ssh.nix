{lib, ...}: let
  mkGitAlias = host: {
    "${host}".user = "git";
  };
in {
  flake.modules.homeManager.desktop.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = lib.mkMerge [
      (mkGitAlias "gitlab.com")
      (mkGitAlias "git.sr.ht")
      (mkGitAlias "github.com")
      (mkGitAlias "codeberg.org")
      (mkGitAlias "gitlab.freedesktop.org")
      {
        "*" = {
          controlMaster = "auto";
          controlPath = "~/.ssh/sockets/master-%r@%n:%p";
          controlPersist = "10m";
        };

        "galileo.sefa.cloud" = {
          user = "root";
        };

        "eclipse.sefa.cloud" = {
          user = "root";
        };

        "scrumplex.net" = {
          user = "root";
        };
      }
    ];
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (lib) mkMerge;

  identityFile = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
  mkGitAlias = host: {
    "${host}" = {
      user = "git";
      inherit identityFile;
    };
  };
in {
  hm.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = mkMerge [
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
        "cosmos.lan" = {
          user = "root";
          identityFile = identityFile;
        };

        "eclipse.sefa.cloud" = {
          user = "root";
          identityFile = identityFile;
        };

        "scrumplex.net" = {
          user = "root";
          identityFile = identityFile;
        };
      }
    ];
  };
}

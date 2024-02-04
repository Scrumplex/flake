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

    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/master-%r@%n:%p";
    controlPersist = "10m";

    matchBlocks = mkMerge [
      (mkGitAlias "gitlab.com")
      (mkGitAlias "git.sr.ht")
      (mkGitAlias "github.com")
      (mkGitAlias "codeberg.org")
      (mkGitAlias "gitlab.freedesktop.org")
      {
        "iss.lan" = {
          user = "root";
          hostname = "10.10.10.1";
          identityFile = identityFile;
        };

        "voyager.lan" = {
          user = "root";
          hostname = "10.10.10.8";
          identityFile = identityFile;
        };

        "cosmos.lan" = {
          user = "root";
          hostname = "10.10.10.11";
          port = 22701;
          identityFile = identityFile;
        };

        "eclipse.lan" = {
          user = "root";
          hostname = "10.10.10.12";
          port = 22701;
          identityFile = identityFile;
        };

        "scrumplex.net" = {
          user = "root";
          port = 22701;
          identityFile = identityFile;
        };

        "duckhub.io" = {
          user = "root";
          port = 22701;
          identityFile = identityFile;
        };
      }
    ];
  };
}

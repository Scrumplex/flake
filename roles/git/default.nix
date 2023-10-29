{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkAliasOptionModule mkIf;

  cfg = config.roles.git;
in {
  options.roles.git = {
    enable = mkEnableOption "git role";
  };

  imports = [
    (mkAliasOptionModule ["roles" "git" "author" "name"] ["hm" "programs" "git" "userName"])
    (mkAliasOptionModule ["roles" "git" "author" "email"] ["hm" "programs" "git" "userEmail"])
    (mkAliasOptionModule ["roles" "git" "author" "gpgKey"] ["hm" "programs" "git" "signing" "key"])
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.roles.gpg.enable -> (builtins.hasAttr "gpgKey" cfg.author);
        message = "As roles.gpg is enabled a value for the Git signing key must be set";
      }
    ];
    hm = {
      home.packages = with pkgs; [git-extras];

      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };

      programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;

        delta = {
          enable = true;
          options.navigate = true;
        };

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
  };
}

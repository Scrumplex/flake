{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [git-extras];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "Sefa Eyeoglu";
    userEmail = "contact@scrumplex.net";
    signing = {
      signByDefault = true;
      key = "E13DFD4B47127951";
    };

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

  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/master-%r@%n:%p";
    controlPersist = "10m";

    matchBlocks = let
      idFile = "~/.ssh/id_ed25519";
    in {
      "aur.archlinux.org" = {
        user = "aur";
        identityFile = idFile;
      };
      "gitlab.com" = {
        user = "git";
        identityFile = idFile;
      };
      "git.sr.ht" = {
        user = "git";
        identityFile = idFile;
      };
      "github.com" = {
        user = "git";
        identityFile = idFile;
      };
      "codeberg.org" = {
        user = "git";
        identityFile = idFile;
      };
      "gitlab.freedesktop.org" = {
        user = "git";
        identityFile = idFile;
      };

      "iss.lan" = {
        user = "root";
        hostname = "10.10.10.1";
        identityFile = idFile;
      };

      "voyager.lan" = {
        user = "root";
        hostname = "10.10.10.8";
        identityFile = idFile;
      };

      "cosmos.lan" = {
        user = "root";
        hostname = "10.10.10.11";
        port = 22701;
        identityFile = idFile;
      };

      "eclipse.lan" = {
        user = "root";
        hostname = "10.10.10.12";
        port = 22701;
        identityFile = idFile;
      };

      "scrumplex.net" = {
        user = "root";
        port = 22701;
        identityFile = idFile;
      };

      "duckhub.io" = {
        user = "root";
        port = 22701;
        identityFile = idFile;
      };
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 1209600;
    defaultCacheTtlSsh = 1209600;
    maxCacheTtl = 1209600;
    maxCacheTtlSsh = 1209600;
    extraConfig = "allow-preset-passphrase";
  };

  services.gnome-keyring.enable = true;

  programs.password-store.enable = true;
}

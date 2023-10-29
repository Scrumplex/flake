{...}: {
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

  services.gnome-keyring.enable = true;

  programs.password-store.enable = true;
}

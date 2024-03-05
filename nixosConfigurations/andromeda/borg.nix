{config, ...}: {
  age.secrets."borgbase-repokey" = {
    file = ../../secrets/andromeda/borgbase-repokey.age;
    owner = "scrumplex";
    inherit (config.users.users.scrumplex) group;
  };

  hm = {
    services.borgmatic = {
      enable = true;
      frequency = "daily";
    };

    # Hacky workaround missing env var for SSH Agent
    # d.bhxq1zzygp4wsptpawmb9am4 is stable as long as programs.gpg.homedir doesn't change!
    systemd.user.services.borgmatic.Service.Environment = "SSH_AUTH_SOCK=%t/gnupg/d.bhxq1zzygp4wsptpawmb9am4/S.gpg-agent.ssh";

    programs.borgmatic = {
      enable = true;
      backups.andromeda = {
        location = {
          repositories = ["ssh://obai58wh@obai58wh.repo.borgbase.com/./repo"];
          sourceDirectories = [config.hm.home.homeDirectory "/media/DATA" "/media/DATA2"];
          extraConfig = {
            exclude_caches = true;
            exclude_if_present = [".nobackup"];
            exclude_patterns = [
              "~/.android"
              "~/.ccache"
              "~/.cargo"
              "~/.chroot"
              "~/.conan"
              "~/.gradle"
              "~/.local/share/baloo"
              "~/.local/share/containers"
              "~/.local/share/JetBrains"
              "~/.local/share/lutris/runners"
              "~/.local/share/lutris/runtime"
              "~/.local/share/PrismLauncher/assets"
              "~/.local/share/PrismLauncher/cache"
              "~/.local/share/PrismLauncher/libraries"
              "~/.local/share/PrismLauncher/meta"
              "~/.local/share/PrismLauncher/metacache"
              "~/.local/share/PrismLauncher/translations"
              "~/.local/share/Steam/appcache"
              "~/.local/share/Steam/compatibilitytools.d"
              "~/.local/share/Steam/config/htmlcache"
              "~/.local/share/Steam/depotcache"
              "~/.local/share/Steam/steamapps"
              "~/.local/share/Trash"
              "~/.local/share/virtualenv"
              "~/.local/share/virtualenvs"
              "~/.m2"
              "~/.node-gyp"
              "~/.npm"
              "~/.nvm"
              "~/.rbenv"
              "~/.rustup"
              "~/.steam"
              "~/.tmp"
              "~/.wine"
              "~/.yarn"
              "~/kde"
              "~/Lutris"
              "/media/DATA/Games"
              "/media/DATA/ItchLibrary"
              "/media/DATA/Torrents"
              "/media/DATA2/SteamLibrary"
              "*/.cache"
              "*/.pnpm-store"
              "*/.snapshots"
              "*/.Trash-*"
            ];
          };
        };
        consistency.checks = [
          {
            name = "repository";
            frequency = "2 weeks";
          }
          {
            name = "archives";
            frequency = "4 weeks";
          }
        ];
        retention = {
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 6;
        };
        storage = {
          encryptionPasscommand = "cat ${config.age.secrets."borgbase-repokey".path}";
          extraConfig.compression = "zstd";
        };
      };
    };
  };
}

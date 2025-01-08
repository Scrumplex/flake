{config, ...}: {
  age.secrets."id_borgbase".file = ../../secrets/andromeda/id_borgbase.age;
  age.secrets."borgbase-repokey".file = ../../secrets/andromeda/borgbase-repokey.age;

  services.borgbackup.jobs."borgbase" = {
    repo = "ssh://obai58wh@obai58wh.repo.borgbase.com/./repo";
    environment.BORG_RSH = "ssh -i ${config.age.secrets."id_borgbase".path}";
    paths = [
      config.hm.home.homeDirectory
      "/media/DATA"
    ];
    inhibitsSleep = true;
    startAt = "13:00";
    exclude = [
      "/home/*/.cargo"
      "/home/*/.config/discord"
      "/home/*/.config/.android"
      "/home/*/.config/r2modman"
      "/home/*/.config/r2modmanPlus-local/*/cache"
      "/home/*/.config/Signal"
      "/home/*/.config/unity3d/cache"
      "/home/*/.dotnet"
      "/home/*/.gradle"
      "/home/*/.local/share/containers"
      "/home/*/.local/share/flatpak"
      "/home/*/.local/share/JetBrains"
      "/home/*/.local/share/lutris/runners"
      "/home/*/.local/share/lutris/runtime"
      "/home/*/.local/share/pnpm"
      "/home/*/.local/share/PrismLauncher/assets"
      "/home/*/.local/share/PrismLauncher/cache"
      "/home/*/.local/share/PrismLauncher/libraries"
      "/home/*/.local/share/PrismLauncher/meta"
      "/home/*/.local/share/PrismLauncher/metacache"
      "/home/*/.local/share/PrismLauncher/translations"
      "/home/*/.local/share/Steam/appcache"
      "/home/*/.local/share/Steam/compatibilitytools.d"
      "/home/*/.local/share/Steam/config/htmlcache"
      "/home/*/.local/share/Steam/depotcache"
      "/home/*/.local/share/Steam/package"
      "/home/*/.local/share/Steam/steamapps"
      "/home/*/.local/share/Steam/ubuntu12_32"
      "/home/*/.local/share/Steam/ubuntu12_64"
      "/home/*/.local/share/Steam/userdata/*/gamerecordings"
      "/home/*/.local/share/Steam/userdata/*/ugc"
      "/home/*/.local/share/syncthing"
      "/home/*/.local/share/TelegramDesktop"
      "/home/*/.local/share/Trash"
      "/home/*/.local/share/unity3d/cache"
      "/home/*/.local/share/virtualenv"
      "/home/*/.local/share/virtualenvs"
      "/home/*/.local/share/yarn"
      "/home/*/.m2"
      "/home/*/.mono"
      "/home/*/.net"
      "/home/*/.npm"
      "/home/*/.paradoxlauncher"
      "/home/*/.platformio"
      "/home/*/.steam"
      "/home/*/.wine"
      "/media/DATA/SteamLibrary"
      "/media/DATA/SteamRecording"
      "*/.cache"
      "*/.git/objects"
      "*/.pnpm-store"
      "*/.snapshots"
      "*/.Trash-*"
      "*/node_modules"
      "*.mega"
    ];
    extraCreateArgs = ["--exclude-caches" "--exclude-if-present" ".nobackup" "--stats"];
    compression = "auto,zstd";
    prune = {
      keep = {
        daily = 7;
        weekly = 4;
        monthly = 6;
        yearly = 1;
      };
      prefix = null;
    };
    encryption = {
      mode = "repokey-blake2";
      passphrase = "";
      passCommand = "cat ${config.age.secrets."borgbase-repokey".path}";
    };

    extraArgs = "-v";
  };

  programs.ssh.knownHosts."borgbase" = {
    hostNames = ["obai58wh.repo.borgbase.com"];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS3185JdDy7ffnr0nLWqVy8FaAQeVh1QYUSiNpW5ESq";
  };
}

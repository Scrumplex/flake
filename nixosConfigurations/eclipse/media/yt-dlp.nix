{
  config,
  pkgs,
  ...
}: let
  user = "media";
  group = "media";

  targetDir = "/media/jellyfin/youtube";
in {
  age.secrets."yt-dlp-targets" = {
    file = ../../../secrets/eclipse/yt-dlp-targets.age;
    owner = user;
    inherit group;
  };

  systemd.services."yt-dlp" = {
    path = with pkgs; [yt-dlp];
    script = ''
      exec yt-dlp \
        --download-archive "$STATE_DIRECTORY/archive.list" \
        --cache-dir "$CACHE_DIRECTORY" \
        --paths "temp:$CACHE_DIRECTORY" \
        --paths "$TARGET_DIR" \
        --output "%(uploader)s/%(title)s.%(ext)s" \
        --playlist-end '16' \
        --match-filter '!is_live' \
        --sub-langs 'all,-live_chat' \
        --embed-subs \
        --embed-thumbnail \
        --embed-metadata \
        --convert-subs 'srt' \
        --ignore-no-formats-error \
        --no-progress \
        --sponsorblock-mark 'all' \
        --merge-output-format 'mp4' \
        --batch-file "${config.age.secrets."yt-dlp-targets".path}"
    '';
    environment = {
      TARGET_DIR = targetDir;
    };
    serviceConfig = {
      User = user;
      Group = group;
      StateDirectory = "yt-dlp";
      CacheDirectory = "yt-dlp";
    };
    startAt = "*:0,30:00";
  };

  systemd.tmpfiles.settings."10-yt-dlp" = {
    ${targetDir}."d" = {
      inherit user group;
    };
  };
}

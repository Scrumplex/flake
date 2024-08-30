{
  imports = [
    ./jellyfin.nix
    ./sabnzbd.nix
    ./servarr.nix
    ./syncthing.nix
    ./transmission.nix
    ./yt-dlp.nix
  ];

  users.groups.media = {
    gid = 976;
  };
  users.users.media = {
    group = "media";
    isSystemUser = true;
    uid = 976;
  };
}

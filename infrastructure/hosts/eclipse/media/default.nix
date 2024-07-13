{
  imports = [
    ./jellyfin.nix
    ./sabnzbd.nix
    ./servarr.nix
    ./syncthing.nix
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

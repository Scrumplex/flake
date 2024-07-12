{
  imports = [
    ./jellyfin.nix
    ./sabnzbd.nix
    ./servarr.nix
  ];

  users.groups.media = {};
  users.users.media = {
    group = "media";
    isSystemUser = true;
    uid = 995;
  };
}

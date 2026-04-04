{
  flake.modules.nixos.ext-media = {
    users = {
      groups.media.gid = 976;
      users.media = {
        group = "media";
        isSystemUser = true;
        uid = 976;
      };
    };
  };
}

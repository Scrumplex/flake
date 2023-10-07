{config, ...}: {
  services.jellyfin.enable = true;

  users.users.${config.services.jellyfin.user}.extraGroups = ["video" "render"];
}

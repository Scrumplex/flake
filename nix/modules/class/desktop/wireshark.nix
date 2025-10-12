{config, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    primaryUser.extraGroups = [config.flake.meta.username];

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}

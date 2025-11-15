{config, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    users.users.${config.flake.meta.username}.extraGroups = ["wireshark"];

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}

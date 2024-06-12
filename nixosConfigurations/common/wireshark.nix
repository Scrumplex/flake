{pkgs, ...}: {
  primaryUser.extraGroups = ["wireshark"];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}

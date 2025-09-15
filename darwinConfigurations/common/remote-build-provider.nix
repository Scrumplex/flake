{pkgs, ...}: {
  users.knownUsers = ["bob-the-builder"];
  users.users.bob-the-builder = {
    uid = 502;
    createHome = true;
    home = "/Users/bob-the-builder";
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0NTTsagVihqSLWR9gHcH6cWkADIQdI1YKEuogq71Gw"
      # getchoo
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpB6mzzsR0vHR/pZ6a60mvMhJS4d0d1TzezbUetXz3i seth@macstadium"
    ];
  };

  nix.settings.trusted-users = ["bob-the-builder"];
}

{...}: {
  users.users.bob-the-builder = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0NTTsagVihqSLWR9gHcH6cWkADIQdI1YKEuogq71Gw"
    ];
  };
  nix.settings.trusted-users = ["bob-the-builder"];
}

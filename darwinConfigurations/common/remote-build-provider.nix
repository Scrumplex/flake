{
  config,
  lib,
  pkgs,
  ...
}: let
  environment = lib.concatStringsSep " " [
    "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  ];

  authorizedNixStoreKey = key: "command=\"${environment} ${config.nix.package}/bin/nix-store --serve --store daemon --write\" ${key}";
in {
  users.knownUsers = ["bob-the-builder"];
  users.users.bob-the-builder = {
    uid = 502;
    createHome = true;
    home = "/Users/bob-the-builder";
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0NTTsagVihqSLWR9gHcH6cWkADIQdI1YKEuogq71Gw"
    ];
  };

  nix.settings.trusted-users = ["bob-the-builder"];
}

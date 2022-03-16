{
  network.description = "nixos";
  network.enableRollback = true;
  network.storage.legacy.databasefile = "./deployment.nixops";

  spacehub = {
    deployment.targetHost = "scrumplex.net";
    deployment.targetPort = 22701;
    deployment.keys.id_borgbase.keyFile = ./secrets/spacehub/id_borgbase;

    imports = [ ./hosts/spacehub/configuration.nix ];
  };

  duckhub = {
    deployment.targetHost = "duckhub.io";
    deployment.targetPort = 22701;
    deployment.keys.id_borgbase.keyFile = ./secrets/duckhub/id_borgbase;

    imports = [ ./hosts/duckhub/configuration.nix ];
  };
}

{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
}:
{
  meta.name = "scrumplex.net";
  meta.description = "scrumplex.net Network";
  meta.nixpkgs = pkgs;

  spacehub = {
    deployment.targetHost = "scrumplex.net";
    deployment.targetPort = 22701;
    deployment.keys.id_borgbase.keyCommand = ["cat" "./secrets/spacehub/id_borgbase"];

    imports = [ ./hosts/spacehub/configuration.nix ];
  };

  duckhub = {
    deployment.targetHost = "duckhub.io";
    deployment.targetPort = 22701;
    deployment.keys.id_borgbase.keyCommand =  ["cat" "./secrets/duckhub/id_borgbase"];

    imports = [ ./hosts/duckhub/configuration.nix ];
  };
}

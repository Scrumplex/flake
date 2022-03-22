{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
}:
{
  meta.name = "scrumplex.net";
  meta.description = "scrumplex.net Network";
  meta.nixpkgs = pkgs;

  defaults = { pkgs, ... }: {
    imports = [ "${sources.agenix}/modules/age.nix" ];
  };

  spacehub = {
    deployment.targetHost = "scrumplex.net";
    deployment.targetPort = 22701;

    age.secrets.id_borgbase.file = secrets/spacehub/id_borgbase.age;

    imports = [ ./hosts/spacehub/configuration.nix ];
  };

  duckhub = {
    deployment.targetHost = "duckhub.io";
    deployment.targetPort = 22701;

    age.secrets.id_borgbase.file = secrets/duckhub/id_borgbase.age;

    imports = [ ./hosts/duckhub/configuration.nix ];
  };
}

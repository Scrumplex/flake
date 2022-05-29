{
    description = "scrumplex.net Infrastructure";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
        agenix.url = "github:ryantm/agenix";
    };

    outputs = { self, nixpkgs, agenix }: {
        colmena = {
            meta.name = "scrumplex.net";
            meta.description = "scrumplex.net Network";
            meta.nixpkgs = import nixpkgs {
                system = "x86_64-linux";
            };

            defaults = { pkgs, ... }: {
                imports = [ "${agenix}/modules/age.nix" ];
            };

            spacehub = {
                deployment.targetHost = "scrumplex.net";
                deployment.targetPort = 22701;

                age.secrets.id_borgbase.file = secrets/spacehub/id_borgbase.age;
                age.secrets."wireguard.key".file = secrets/spacehub/wireguard.key.age;

                imports = [ ./hosts/spacehub ];
            };

            duckhub = {
                deployment.targetHost = "duckhub.io";
                deployment.targetPort = 22701;

                age.secrets.id_borgbase.file = secrets/duckhub/id_borgbase.age;
                age.secrets."wireguard.key".file = secrets/duckhub/wireguard.key.age;

                imports = [ ./hosts/duckhub ];
            };
        };
    };
}

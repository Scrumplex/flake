{inputs, ...}: let
  inherit (inputs) agenix arion nixos-hardware nixpkgs skinprox;
in {
  flake = {
    colmena = {
      meta.name = "scrumplex.net";
      meta.description = "scrumplex.net Network";
      meta.nixpkgs = {inherit (nixpkgs) lib;};
      meta.nodeNixpkgs = {
        universe = nixpkgs.legacyPackages.x86_64-linux;
        cosmos = nixpkgs.legacyPackages.aarch64-linux;
        eclipse = nixpkgs.legacyPackages.x86_64-linux;
      };
      meta.specialArgs = {inherit inputs;};

      defaults.imports = [../modules/oci-image-external.nix agenix.nixosModules.age arion.nixosModules.arion];

      universe = {
        deployment.targetHost = "scrumplex.net";
        deployment.targetPort = 22701;

        age.secrets.id_borgbase.file = ../secrets/universe/id_borgbase.age;
        age.secrets.borgbase_repokey.file = ../secrets/universe/borgbase_repokey.age;
        age.secrets."murmur.env".file = ../secrets/universe/murmur.env.age;
        age.secrets."wireguard.key".file = ../secrets/universe/wireguard.key.age;
        age.secrets."hetzner.key".file = ../secrets/universe/hetzner.key.age;
        age.secrets."hedgedoc-service.env".file = ../secrets/universe/hedgedoc-service.env.age;
        age.secrets."nextcloud-service.env".file = ../secrets/universe/nextcloud-service.env.age;
        age.secrets."refraction-service.env".file = ../secrets/universe/refraction-service.env.age;
        age.secrets."scrumplex-x-service.env".file = ../secrets/universe/scrumplex-x-service.env.age;
        age.secrets."tor-service.env".file = ../secrets/universe/tor-service.env.age;

        nixpkgs.overlays = [
          skinprox.overlays.default
        ];
        imports = [
          skinprox.nixosModules.skinprox
          ../hosts/universe
        ];
      };

      cosmos = {
        deployment.targetHost = "cosmos.lan";
        deployment.targetPort = 22701;

        age.secrets.id_borgbase.file = ../secrets/cosmos/id_borgbase.age;
        age.secrets."wireguard.key".file = ../secrets/cosmos/wireguard.key.age;
        age.secrets."hetzner.key".file = ../secrets/cosmos/hetzner.key.age;

        imports = [
          nixos-hardware.nixosModules.raspberry-pi-4
          ../hosts/cosmos
        ];
      };

      eclipse = {
        deployment.targetHost = "eclipse.lan";
        deployment.targetPort = 22701;

        age.secrets."ca_intermediate.key" = {
          file = ../secrets/eclipse/ca_intermediate.key.age;
          owner = "step-ca";
          group = "step-ca";
        };
        age.secrets."ca_intermediate.pass" = {
          file = ../secrets/eclipse/ca_intermediate.pass.age;
          owner = "step-ca";
          group = "step-ca";
        };
        age.secrets."hetzner.key".file = ../secrets/eclipse/hetzner.key.age;
        age.secrets.id_borgbase.file = ../secrets/eclipse/id_borgbase.age;
        age.secrets.paperless-password.file = ../secrets/eclipse/paperless-password.age;
        age.secrets."transmission-creds.json".file = ../secrets/eclipse/transmission-creds.json.age;

        imports = [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
          ../hosts/eclipse
        ];
      };
    };
  };
}

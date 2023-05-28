{
  config,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.attrsets) filterAttrs;
  inherit (lib.modules) mkMerge;

  mkContainer = args @ {
    name,
    externalImage ? name,
    ...
  }: {
    ${name} =
      {
        image = config.virtualisation.oci-containers.externalImages.images.${externalImage}.ref;
      }
      // (filterAttrs (n: _: ! elem n ["name" "externalImage"]) args);
  };
in {
  virtualisation.oci-containers.containers = mkMerge [
    (mkContainer rec {
      name = "scrumplex-website";
      extraOptions = [
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.${name}.rule=Host(`scrumplex.net`)"
        "-l=traefik.http.routers.${name}.entrypoints=websecure"
      ];
    })
  ];
}

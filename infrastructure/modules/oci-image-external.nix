{
  config,
  lib,
  ...
}: let
  inherit (builtins) fromJSON readFile;
  inherit (lib) types;
  inherit (lib.attrsets) mapAttrs mapAttrsToList;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkOption;

  cfg = config.virtualisation.oci-containers.externalImages;

  imageRef = types.submodule {
    options = {
      registry = mkOption {
        readOnly = true;
        type = types.str;
      };
      repository = mkOption {
        readOnly = true;
        type = types.str;
      };
      tag = mkOption {
        readOnly = true;
        type = types.str;
      };
      ref = mkOption {
        readOnly = true;
        type = types.str;
      };
    };
  };
in {
  options.virtualisation.oci-containers.externalImages = {
    imagesFile = mkOption {
      description = "Path to configuration file containing image references";
      type = types.path;
    };

    defaultRegistry = mkOption {
      default = "docker.io";
      description = "Default registry to use when unspecified";
      type = types.str;
    };

    images = mkOption {
      description = "Image references";
      type = types.attrsOf imageRef;
    };
  };

  config = let
    defaultImageOpts = {registry = cfg.defaultRegistry;};

    mkImageRef = image: let
      inherit (image') registry repository tag;

      image' = defaultImageOpts // image;
    in
      image' // {ref = "${registry}/${repository}:${tag}";};

    images = fromJSON (readFile cfg.imagesFile);
    images' = mapAttrs (_: v: mkImageRef v) images;
  in {
    virtualisation.oci-containers.externalImages.images = images';
  };
}

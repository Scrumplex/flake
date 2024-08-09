{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkIf;
  inherit (lib.options) literalExpression mkOption;

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

  readYAML = file: let
    inherit (builtins) fromJSON readFile;
    inherit (pkgs) runCommand yj;
    # convert to json
    json = runCommand "converted.json" {} ''
      ${yj}/bin/yj < ${file} > $out
    '';
  in
    fromJSON (readFile json);

  defaultImageOpts = {registry = cfg.defaultRegistry;};

  mkImageRef = image: let
    inherit (image') registry repository tag;

    image' = defaultImageOpts // image.image;
  in
    image' // {ref = "${registry}/${repository}:${tag}";};

  images = readYAML cfg.imagesFile;
  images' = mapAttrs (_: v: mkImageRef v) images;
in {
  options.virtualisation.oci-containers.externalImages = {
    imagesFile = mkOption {
      description = "Path to configuration file containing image references";
      type = types.path;
      example = literalExpression "./values.yaml";
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

  config = mkIf (cfg.imagesFile != null) {
    virtualisation.oci-containers.externalImages.images = images';
  };
}

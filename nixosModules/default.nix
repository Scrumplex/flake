{
  flake.nixosModules = {
    borgbase = ./borgbase.nix;
    oci-image-external = ./oci-image-external.nix;
    ustreamer = ./ustreamer.nix;
  };
}

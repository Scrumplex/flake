{
  flake.nixosModules = {
    borgbase = ./borgbase.nix;
    hetzner-dyndns = ./hetzner-dyndns.nix;
    oci-image-external = ./oci-image-external.nix;
  };
}

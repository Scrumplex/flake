{pkgs, ...}: {
  virtualisation.oci-containers.externalImages.imagesFile = ../../values.yaml;

  environment.systemPackages = with pkgs; [kitty.terminfo htop nload tcpdump];

  networking.useNetworkd = true;
}

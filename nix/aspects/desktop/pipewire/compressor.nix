{
  flake.aspects."desktop"._."pipewire".homeManager = {pkgs, ...}: {
    services.pipewire.instances."compressor" = {
      config = ./compressor.conf;
      extraPackages = [pkgs.calf];
    };
  };
}

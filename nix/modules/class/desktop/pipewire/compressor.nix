{
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    services.pipewire.instances.compressor = {
      config = ./compressor.conf;
      extraPackages = [pkgs.calf];
    };
  };
}

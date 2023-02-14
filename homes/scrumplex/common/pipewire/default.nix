{ config, pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    instances = {
      compressor = {
        config = ./compressor.conf;
        extraPackages = [ pkgs.calf ];
      };
      desktop-source = { config = ./desktop-source.conf; };
      #equalizer = {
      #  config = ./equalizer.conf;
      #  extraPackages = [ pkgs.lsp-plugins ];
      #};
    };
  };
}

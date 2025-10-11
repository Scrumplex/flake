{
  flake.modules.homeManager.desktop = {
    services.pipewire.instances.desktop-source = {
      config = ./desktop-source.conf;
    };
  };
}

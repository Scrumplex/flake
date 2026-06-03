{
  flake.aspects."desktop"._."pipewire".homeManager = {
    services.pipewire.instances."desktop-source" = {
      config = ./desktop-source.conf;
    };
  };
}

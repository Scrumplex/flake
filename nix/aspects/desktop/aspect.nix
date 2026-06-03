{
  flake.aspects = {aspects, ...}: {
    "desktop" = {
      includes = [aspects.desktop._.pipewire];
      nixos = {};
      homeManager = {};
    };
  };
}

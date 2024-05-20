{inputs, ...}: {
  nixpkgs.overlays = [inputs.inhibridge.overlays.default];

  hm = {
    imports = [inputs.inhibridge.homeModules.default];

    services.inhibridge.enable = true;
  };
}

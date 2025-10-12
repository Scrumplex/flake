{inputs, ...}: {
  flake.modules.nixos.desktop = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  flake.modules.homeManager.desktop = {
    imports = [inputs.scrumpkgs.hmModules.pipewire];
    services.pipewire.enable = true;
  };
}

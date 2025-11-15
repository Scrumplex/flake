{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.desktop = {
    users.users.${config.flake.meta.username}.extraGroups = [
      "audio"
    ];

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

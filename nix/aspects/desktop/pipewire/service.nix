{config, ...}: {
  flake.aspects = {aspects, ...}: {
    "desktop"._."pipewire" = {
      includes = with aspects; [pipewire-instances];
      nixos = {
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
      homeManager = {
        services.pipewire.enable = true;
      };
    };
  };
}

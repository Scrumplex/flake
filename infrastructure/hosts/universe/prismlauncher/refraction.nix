{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.refraction.nixosModules.default
  ];
  nixpkgs.overlays = [inputs.refraction.overlays.default];

  age.secrets."prism-refraction.env" = {
    file = ../../../secrets/universe/prism-refraction.env.age;
    owner = config.services.refraction.user;
    inherit (config.services.refraction) group;
  };

  services.refraction = {
    enable = true;
    package = pkgs.refraction; # overlay
    environmentFile = config.age.secrets."prism-refraction.env".path;
  };
}

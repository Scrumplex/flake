{
  config,
  inputs,
  pkgs,
  ...
}: {
  age.secrets."murmur.env".file = ../../secrets/universe/murmur.env.age;

  services.murmur = {
    enable = true;
    openFirewall = true;
    package = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.murmur;
    environmentFile = config.age.secrets."murmur.env".path;

    welcometext = ''
      <br />Welcome to scrumplex.net<br />
    '';

    registerUrl = "https://scrumplex.net/";
    registerName = "scrumplex.net";
    registerHostname = "scrumplex.net";
    registerPassword = "$MURMUR_REGISTER_PASSWORD";

    bandwidth = 128000;
  };
}

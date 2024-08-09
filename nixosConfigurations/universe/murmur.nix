{config, ...}: {
  age.secrets."murmur.env".file = ../../secrets/universe/murmur.env.age;

  services.murmur = {
    enable = true;
    openFirewall = true;
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

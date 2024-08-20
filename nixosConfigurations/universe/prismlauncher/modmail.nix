{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.modmail.nixosModules.modmail-with-overlay];
  nixpkgs.overlays = [inputs.self.overlays.default];

  age.secrets."prism-modmail.env".file = ../../../secrets/universe/prism-modmail.env.age;
  age.secrets."prism-oauth2-proxy.env".file = ../../../secrets/universe/prism-oauth2-proxy.env.age;

  services.modmail = {
    enable = true;
    settings = {
      LOG_URL = "https://logs.prismlauncher.org/";
      GUILD_ID = "1031648380885147709";
      OWNERS = "138352803906191360";
      # CONNECTION_URI and TOKEN are set in env file
    };
    environmentFile = config.age.secrets."prism-modmail.env".path;
  };

  systemd.services."logviewer" = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    environment = {
      LOG_URL_PREFIX = "/logs";
      HOST = "127.0.0.1";
      PORT = "4179";
      # CONNECTION_URI set in env file
    };

    serviceConfig = {
      ExecStart = lib.getExe pkgs.logviewer;
      EnvironmentFile = [config.age.secrets."prism-modmail.env".path];
      LogsDirectory = "logviewer";
      WorkingDirectory = "%L/logviewer";

      DynamicUser = true;
    };
  };

  services.oauth2-proxy = {
    enable = true;

    keyFile = config.age.secrets."prism-oauth2-proxy.env".path;

    reverseProxy = true;
    httpAddress = "127.0.0.1:4180";
    extraConfig = {
      skip-provider-button = true;
      whitelist-domain = ".prismlauncher.org";
    };
    clientID = "28f90269976cec966d4a";

    cookie = {
      secure = true;
      expire = "30m0s";
    };
    email.domains = ["*"];

    provider = "github";
    scope = "user:email,read:org";
    github.org = "PrismLauncher";

    upstream = ["http://localhost:4179"];
  };

  services.nginx = {
    upstreams.prismlogs.servers.${config.services.oauth2-proxy.httpAddress} = {};
    virtualHosts."logs.prismlauncher.org" = lib.mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      {
        locations."/".proxyPass = "http://prismlogs";
      }
    ];
  };
}

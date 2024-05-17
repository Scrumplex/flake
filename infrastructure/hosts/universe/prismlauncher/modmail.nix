{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.self.overlays.default];

  age.secrets."prism-modmail.env".file = ../../../secrets/universe/prism-modmail.env.age;

  systemd.services."modmail" = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    environment = {
      LOG_URL = "https://logs.prismlauncher.org/";
      GUILD_ID = "1031648380885147709";
      OWNERS = "138352803906191360";
      # CONNECTION_URI and TOKEN are set in env file
    };

    serviceConfig = {
      ExecStart = lib.getExe pkgs.modmail;
      EnvironmentFile = [config.age.secrets."prism-modmail.env".path];
      LogsDirectory = "modmail";
      WorkingDirectory = "%L/modmail";

      DynamicUser = true;
    };
  };

  services.nginx = {
    upstreams.prismlogs.servers."localhost:4180" = {};
    virtualHosts."logs.prismlauncher.org" = lib.mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      {
        locations."/".proxyPass = "http://prismlogs";
      }
    ];
  };
}

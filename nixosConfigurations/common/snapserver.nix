{
  config,
  lib,
  pkgs,
  ...
}: {
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [mopidy-jellyfin];
    configuration = ''
      [audio]
      output = audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! wavenc ! tcpclientsink host=127.0.0.1 port=4953
    '';
  };

  services.snapserver = {
    enable = true;
    openFirewall = true;
    http = {
      enable = true;
      listenAddress = "0.0.0.0";
      docRoot = pkgs.snapweb;
    };
    streams = {
      Mopidy = {
        type = "tcp";
        location = "127.0.0.1:4953";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [config.services.snapserver.http.port];
}

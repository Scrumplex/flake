{pkgs, ...}: {
  programs.adb.enable = true;
  services.openssh.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      22000 # syncthing
    ];
    allowedUDPPorts = [
      21027 # syncthing
      22000 # syncthing
    ];
  };

  services.udev.packages = with pkgs; [zoom65-udev-rules];

  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = ["NOPASSWD"];
        }
        {
          command = "${pkgs.systemd}/bin/systemctl";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  security.pki.certificates = [(builtins.readFile ../../misc/root_ca.crt)];
}

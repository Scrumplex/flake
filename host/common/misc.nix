{pkgs, ...}: {
  programs.adb.enable = true;
  programs.mtr.enable = true;
  programs.bandwhich.enable = true;
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
      24727 # AusweisApp2
    ];
  };

  services.udev.packages = with pkgs; [zoom65-udev-rules];

  # Taken from NixOS qt module
  environment.profileRelativeSessionVariables = let
    qtVersions = with pkgs; [qt5 qt6];
  in {
    QT_PLUGIN_PATH = map (qt: "/${qt.qtbase.qtPluginPrefix}") qtVersions;
    QML2_IMPORT_PATH = map (qt: "/${qt.qtbase.qtQmlPrefix}") qtVersions;
  };

  security.sudo = {
    extraConfig = ''
      Defaults lecture = always
      Defaults lecture_file = ${../../misc/lecture.txt}
      Defaults pwfeedback
      Defaults passwd_timeout=0
    '';
    extraRules = [
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
          {
            command = "/run/current-system/sw/bin/podman";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  services.udisks2.enable = true;

  security.pki.certificates = [(builtins.readFile ../../misc/root_ca.crt)];
}

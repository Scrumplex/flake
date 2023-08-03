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
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/systemctl";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  services.udisks2.enable = true;

  security.pki.certificates = [(builtins.readFile ../../misc/root_ca.crt)];
}

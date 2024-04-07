{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  hm.catppuccin.flavour = "mocha";
  users.mutableUsers = false;

  services.openssh.enable = true;
  virtualisation.podman = {
    enable = mkDefault true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  security.sudo = {
    extraConfig = ''
      Defaults lecture = always
      Defaults lecture_file = ${../../misc/lecture.txt}
      Defaults pwfeedback
      Defaults passwd_timeout=0
    '';
  };

  environment.systemPackages = with pkgs; [just];

  security.pki.certificates = [(builtins.readFile ../../misc/root_ca.crt)];

  programs.adb.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      22000 # syncthing
      25565 # minecraft
    ];
    allowedUDPPorts = [
      21027 # syncthing
      22000 # syncthing
      24727 # AusweisApp2
      25565 # minecraft
    ];
  };

  services.udev.packages = with pkgs; [zoom65-udev-rules];

  services.udisks2.enable = true;

  security.sudo.extraRules = [
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
}

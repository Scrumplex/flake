{pkgs, ...}: {
  boot.tmpOnTmpfs = true;

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

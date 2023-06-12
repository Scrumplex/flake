{pkgs, ...}: {
  services.swayidle.timeouts = [
    {
      timeout = 600;
      command = "${pkgs.systemd}/bin/systemctl} suspend";
    }
  ];
}

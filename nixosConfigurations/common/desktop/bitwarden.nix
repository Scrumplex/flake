{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.bitwarden-desktop
  ];

  hm.home.sessionVariables."SSH_AUTH_SOCK" = "${config.hm.home.homeDirectory}/.bitwarden-ssh-agent.sock";

  hm.xdg.autostart.entries = [
    "${pkgs.bitwarden-desktop}/share/applications/bitwarden.desktop"
  ];
}

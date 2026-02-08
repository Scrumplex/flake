{
  flake.modules.nixos."desktop" = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.bitwarden-desktop
    ];
  };

  flake.modules.homeManager."desktop" = {
    config,
    pkgs,
    ...
  }: {
    home.sessionVariables."SSH_AUTH_SOCK" = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

    xdg.autostart.entries = [
      "${pkgs.bitwarden-desktop}/share/applications/bitwarden.desktop"
    ];
  };
}

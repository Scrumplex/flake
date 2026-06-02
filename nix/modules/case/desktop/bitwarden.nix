{
  flake.modules.nixos."desktop" = {pkgs, ...}: {
    nixpkgs.config.permittedInsecurePackages = builtins.warn "permitting electron-39 as insecure package" [
      "electron-39.8.10"
    ];

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

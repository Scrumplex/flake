{ config, pkgs, ... }:

{
  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands = [{
      command = "${pkgs.systemd}/bin/systemctl";
      options = [ "NOPASSWD" ];
    }];
  }];

  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" ];
}

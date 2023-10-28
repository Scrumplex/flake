{
  config,
  lib,
  pkgs,
  ...
}: {
  roles.base.username = "A105227727";
  hm.home.homeDirectory = lib.mkForce "/Users/A105227727";

  system.activationScripts.applications.text = pkgs.lib.mkForce ''
      username="${config.roles.base.username}"
      echo "setting up ~/Applications/Nix..."
      rm -rf "/Users/$username/Applications/Nix"
      install -d -o "$username" -g staff "/Users/$username/Applications/Nix"
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
        src="$(/usr/bin/stat -f%Y $f)"
        appname="$(basename $src)"
        osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/$username/Applications/Nix/\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
    done
  '';

  homebrew = {
    enable = true;
    casks = ["mac-mouse-fix"];
  };

  environment.systemPackages = with pkgs; [
    iterm2
    rectangle
    keepassxc
  ];

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true; # default shell on catalina

  system.stateVersion = 4;
  hm.home.stateVersion = "23.05";
}

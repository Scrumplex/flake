{
  config,
  lib,
  pkgs,
  ...
}: let
  username = "A105227727";
in {
  hm.home.homeDirectory = lib.mkForce "/Users/A105227727";
  hm.xdg.enable = true;

  # refactor?
  roles.catppuccin = {
    enable = true;
    flavor = "mocha";
  };
  roles.git = {
    enable = true;
    author = {
      name = "Sefa Eyeoglu";
      email = "sefa.eyeoglu@telekom.de";
    };
  };
  roles.neovim.enable = true;
  roles.shell.enable = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;
      ApplePressAndHoldEnabled = false;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "WhenScrolling";
      InitialKeyRepeat = 15; # unit is 15ms, so 500ms
      KeyRepeat = 2; # unit is 15ms, so 30ms
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.05;
      minimize-to-application = true;
      orientation = "left";
      show-recents = false;
    };
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
    };
  };

  system.activationScripts.applications.text = pkgs.lib.mkForce ''
      username="${username}"
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
    casks = [
      "browserosaurus"
      # not supported on aarch64-darwin in nixpkgs
      "caffeine"
      "jabra-direct"
      "mac-mouse-fix"
    ];
  };

  environment.systemPackages = with pkgs; [
    iterm2
    rectangle
    keepassxc

    lima
    colima
    docker-client
  ];

  services.nix-daemon.enable = true;
  nix = {
    gc.automatic = true;
    linux-builder = {
      enable = true;
      maxJobs = 4;
    };
    settings.experimental-features = "nix-command flakes";
  };

  programs.zsh.enable = true; # default shell on catalina

  system.stateVersion = 4;
  hm.home.stateVersion = "23.05";
}

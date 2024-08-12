{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.mac-app-util.darwinModules.default ./neovim.nix ./kitty.nix];
  home-manager.sharedModules = [inputs.mac-app-util.homeManagerModules.default];
  roles.base.username = "A105227727";
  hm.home.homeDirectory = lib.mkForce "/Users/A105227727";
  hm.xdg.enable = true;

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
  roles.shell.enable = true;

  nixpkgs.config.allowUnfree = true;

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

  homebrew = {
    enable = true;
    brews = [
      "lima"
      "colima"
      "docker"
      "docker-compose"
    ];
    casks = [
      "boop"
      "browserosaurus"
      "bruno"
      # not supported on aarch64-darwin in nixpkgs
      "caffeine"
      "hoppscotch"
      "inkscape"
      "jabra-direct"
      "jellyfin-media-player"
      "linearmouse"
      "pgadmin4"
      "postman"
      "signal"
      "core-tunnel"
      "syncthing"
      "visual-studio-code"
    ];
  };
  environment.systemPath = [config.homebrew.brewPrefix];

  environment.systemPackages = with pkgs; [
    htop
    iterm2
    rectangle

    fluxcd
    k9s
    kubectl
    kubectx
    awscli2
    cosign
    skopeo
  ];

  hm.xdg.configFile."k9s/plugins.yaml".source = pkgs.fetchurl {
    name = "k9s-flux-plugin.yaml";
    url = "https://github.com/derailed/k9s/raw/350439b98553f23672f7ce0b650637d0afdd4104/plugins/flux.yaml";
    hash = "sha256-YlKmFPUNG+v3YK2tbZMMNO//qJNSgmMIDdj+31A4t/8=";
  };

  services.nix-daemon.enable = true;
  nix = {
    gc.automatic = true;
    linux-builder = {
      enable = true;
      maxJobs = 4;
    };
    settings.experimental-features = "nix-command flakes";

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    registry.n.flake = inputs.nixpkgs;
  };

  programs.zsh.enable = true; # default shell on catalina

  system.stateVersion = 4;
  hm.home.stateVersion = "23.05";
}

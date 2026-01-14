{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    ./neovim.nix

    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" "A105227727"])
  ];
  system.primaryUser = "A105227727";
  hm.xdg.enable = true;

  programs.nix-index-database.comma.enable = true;

  programs.fish.enable = true;
  programs.zsh.enable = true;
  users.users."A105227727".shell = pkgs.fish;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules =
      builtins.attrValues inputs.scrumpkgs.hmModules
      ++ [
        inputs.catppuccin.homeModules.catppuccin
      ];
    extraSpecialArgs = {
      inherit inputs;
      lib' = inputs.scrumpkgs.lib;
    };
  };

  hm.catppuccin = {
    enable = true;
    flavor = "mocha";
    bat.enable = true;
    btop.enable = true;
    fish.enable = true;
    kitty.enable = true;
  };
  hm = {
    home.username = "A105227727";
    home.homeDirectory = lib.mkForce "/Users/A105227727";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      file
      libqalculate
      parallel
      fzf
      ripgrep
      tree
      git-extras
    ];
    programs.fish = {
      enable = true;
      shellInit = ''
        set -g theme_color_scheme "catppuccin"
        set -g theme_nerd_fonts "yes"
        set -g theme_title_display_process "yes"
      '';

      functions.aws-profile = ''
        function aws-profile -a profile
          set -l current_profile default
          set -q AWS_PROFILE && set current_profile $AWS_PROFILE

          set -gx AWS_PROFILE $profile
          if set -q profile
            set -gx AWS_PROFILE (aws configure list-profiles | fzf)
          end
          echo "Switched from $current_profile to $AWS_PROFILE"
        end
      '';

      shellAliases = lib.mkMerge [
        {
          ll = "ls --long --all --classify=always";
          ls = "eza"; # note: we rely on the alias created by eza
        }
      ];
      plugins = with pkgs.fishPlugins; [
        {
          name = "autopair.fish";
          inherit (autopair-fish) src;
        }
        {
          name = "bobthefisher";
          inherit (bobthefisher) src;
        }
        {
          name = "fzf";
          inherit (fzf) src;
        }
        {
          name = "humantime.fish";
          inherit (humantime-fish) src;
        }
        {
          name = "puffer";
          inherit (puffer) src;
        }
        {
          name = "z";
          inherit (z) src;
        }
      ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.eza = {
      enable = true;
      icons = "auto";
    };

    programs.fish.shellAbbrs = {
      g = "git";
      ga = "git add";
      gap = "git add -p";
      gca = "git commit -s --amend";
      gcm = "git commit -sm";
      gco = "git checkout";
      gd = "git diff";
      gdc = "git diff --cached";
      gl = "git log";
      gp = "git push";
      gpl = "git pull";
      gri = "git rebase --interactive";
      grc = "git rebase --continue";
      gs = "git status";
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    programs.mergiraf.enable = true;

    programs.git = {
      enable = true;

      userName = "Sefa Eyeoglu";
      userEmail = "sefa.eyeoglu@telekom.de";

      delta = {
        enable = true;
        options.navigate = true;
      };

      extraConfig = {
        core.autocrlf = "input";
        color.ui = "auto";
        diff.colorMoved = "default";
        push.followTags = true;
        pull.rebase = true;
        init.defaultBranch = "main";
        url = {
          "https://github.com/".insteadOf = "github:";
          "ssh://git@github.com/".pushInsteadOf = "github:";
          "https://gitlab.com/".insteadOf = "gitlab:";
          "ssh://git@gitlab.com/".pushInsteadOf = "gitlab:";
          "https://aur.archlinux.org/".insteadOf = "aur:";
          "ssh://aur@aur.archlinux.org/".pushInsteadOf = "aur:";
          "https://git.sr.ht/".insteadOf = "srht:";
          "ssh://git@git.sr.ht/".pushInsteadOf = "srht:";
          "https://codeberg.org/".insteadOf = "codeberg:";
          "ssh://git@codeberg.org/".pushInsteadOf = "codeberg:";
        };
      };
    };

    programs.kitty = {
      enable = true;
      font.name = "FiraCode Nerd Font Mono";
      settings = {
        disable_ligatures = "cursor";
        paste_actions = "quote-urls-at-prompt";
        placement_strategy = "top-left";
        tab_bar_style = "powerline";
        update_check_interval = 0;
        shell = "/run/current-system/sw/bin/fish";
      };
      shellIntegration.mode = "no-cursor";
    };
  };

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
      "docker-buildx"
      "docker-compose"
    ];
    casks = [
      "boop"
      "browserosaurus"
      # not supported on aarch64-darwin in nixpkgs
      "caffeine"
      "jabra-direct"
      "jellyfin-media-player"
      "linearmouse"
      "core-tunnel"
      "session-manager-plugin"
      "syncthing"
      "visual-studio-code"
    ];
  };
  environment.systemPath = [config.homebrew.brewPrefix];

  environment.systemPackages = with pkgs; [
    config.hm.programs.kitty.package
    htop
    bruno
    hoppscotch
    inkscape
    pgadmin4-desktopmode
    rectangle
    signal-desktop-bin
    slack
    (discord.override {withVencord = true;})
    alt-tab-macos

    #inputs.flox.packages.${pkgs.system}.flox
    fluxcd
    k9s
    kubectl
    kubectx
    awscli2
    #cosign
    skopeo
  ];

  hm.xdg.configFile."k9s/plugins.yaml".source = "${pkgs.k9s.src}/plugins/flux.yaml";

  nix = {
    enable = true;
    gc.automatic = true;
    linux-builder = {
      enable = true;
      maxJobs = 4;
      ephemeral = true;
    };
    settings.experimental-features = "nix-command flakes";
    settings.trusted-users = ["A105227727"];
    settings.trusted-substituters = ["https://cache.flox.dev"];
    settings.trusted-public-keys = ["flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="];

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    registry.n.flake = inputs.nixpkgs;
  };

  ids.gids.nixbld = 350;

  system.stateVersion = 4;
  hm.home.stateVersion = "23.05";
}

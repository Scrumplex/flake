{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.desktop = {
    nixpkgs.overlays = [inputs.noctalia.overlays.default];

    security.pam.services.noctalia = {};
  };

  flake.modules.homeManager.desktop = {
    config,
    pkgs,
    ...
  }: let
    termapp = "${pkgs.termapp}/bin/termapp";
  in {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.sessionVariables."NOCTALIA_PAM_SERVICE" = "noctalia";

    programs.noctalia-shell = {
      enable = true;
      package = pkgs.noctalia-shell.override {calendarSupport = true;};
      systemd.enable = true;
      settings = {
        appLauncher = {
          density = "default";
          iconMode = "native";
          position = "center";
          terminalCommand = termapp;
        };
        controlCenter = {
          shortcuts = {
            left = [
              {
                "id" = "Network";
              }
              {
                "id" = "Bluetooth";
              }
              {
                "id" = "PowerProfile";
              }
            ];
            right = [
              {
                "id" = "Notifications";
              }
              {
                "id" = "KeepAwake";
              }
              {
                "id" = "NightLight";
              }
            ];
          };
          cards = [
            {
              "enabled" = true;
              "id" = "profile-card";
            }
            {
              "enabled" = true;
              "id" = "shortcuts-card";
            }
            {
              "enabled" = true;
              "id" = "audio-card";
            }
            {
              "enabled" = true;
              "id" = "brightness-card";
            }
            {
              "enabled" = true;
              "id" = "weather-card";
            }
            {
              "enabled" = true;
              "id" = "media-sysmon-card";
            }
          ];
        };
        bar = {
          barType = "simple";
          density = "default";
          displayMode = "always_visible";
          position = "top";
          showCapsule = false;
          widgetSpacing = 4;
          widgets = {
            center = [
              {
                formatHorizontal = "HH:mm:ss";
                formatVertical = "HH mm ss";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
              }
            ];
            left = [
              {
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
              }
              {
                id = "MediaMini";
                maxWidth = 500;
                showVisualizer = true;
              }
            ];
            right = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                displayMode = "alwaysShow";
                id = "Volume";
                middleClickCommand = "${termapp} ${pkgs.pulsemixer}/bin/pulsemixer";
              }
              {
                displayMode = "alwaysShow";
                id = "Brightness";
              }
              {
                displayMode = "graphic";
                id = "Battery";
                showPowerProfiles = true;
              }
              {
                id = "KeepAwake";
              }
              {
                formatHorizontal = "ddd, dd. MMM yyyy";
                formatVertical = "ddd dd MMM yyyy";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, dd. MMM yyyy";
              }
              {
                drawerEnabled = false;
                id = "Tray";
              }
              {
                hideWhenZero = false;
                id = "NotificationHistory";
              }
            ];
          };
        };
        colorSchemes = {
          darkMode = true;
          predefinedScheme = "Catppuccin";
        };
        desktopWidgets.enabled = false;
        dock.enabled = false;
        audio = {
          preferredPlayer = "mpd";
          volumeFeedback = true;
        };
        nightLight = {
          enabled = true;
          autoSchedule = true;
          nightTemp = "4017";
          dayTemp = "6500";
        };
        idle = {
          enabled = true;
          screenOffTimeout = 120;
          lockTimeout = 300;
          suspendTimeout = 1800;
          fadeDuration = 10;
        };
        general = {
          allowPasswordWithFprintd = true;
          animationSpeed = 2;
          avatarImage = "${config.home.homeDirectory}/.face";
          autoStartAuth = true;
          clockFormat = "hh\\nmm";
          clockStyle = "analog";
          compactLockScreen = false;
          dimmerOpacity = 0.2;
          enableBlurBehind = true;
          enableLockScreenCountdown = true;
          enableLockScreenMediaControls = true;
          enableShadows = false;
          forceBlackScreenCorners = false;
          iRadiusRatio = 1;
          lockOnSuspend = true;
          lockScreenAnimations = true;
          lockScreenBlur = 0;
          lockScreenCountdownDuration = 10000;
          lockScreenMonitors = [];
          lockScreenTint = 0;
          passwordChars = false;
          radiusRatio = 0.2;
          reverseScroll = false;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          showChangelogOnStartup = true;
          showHibernateOnLockScreen = false;
          showScreenCorners = false;
          showSessionButtonsOnLockScreen = true;
          telemetryEnabled = false;
        };
        location.name = "Essen, Germany";
        noctaliaPerformance = {
          disableDesktopWidgets = true;
          disableWallpaper = true;
        };
        osd = {
          autoHideMs = 500;
          location = "top_center";
        };
        settingsVersion = 59;
        systemMonitor.externalMonitor = "${termapp} ${lib.getExe pkgs.btop}";
        ui = {
          boxBorderEnabled = false;
          fontDefault = "Monocraft";
          fontDefaultScale = 1;
          fontFixed = "Monocraft";
          fontFixedScale = 1;
          panelBackgroundOpacity = 0.95;
          panelsAttachedToBar = true;
          scrollbarAlwaysVisible = true;
          settingsPanelMode = "window";
          settingsPanelSideBarCardStyle = false;
          tooltipsEnabled = true;
          translucentWidgets = true;
        };
      };
    };
  };
}

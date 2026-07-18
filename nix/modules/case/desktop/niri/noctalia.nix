{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.desktop = {
    nixpkgs.overlays = [inputs.noctalia.overlays.default];

    services.upower.enable = true;
  };

  flake.modules.homeManager.desktop = {
    pkgs,
    osConfig,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.sessionVariables."NOCTALIA_PAM_SERVICE" = "noctalia";

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      package = pkgs.noctalia;
      settings = {
        audio.enable_sounds = true;
        bar = {
          default = {
            background_opacity = 0.9;
            capsule = true;
            end = [
              (lib.mkIf osConfig.networking.networkmanager.enable "network")
              "bluetooth"
              "volume"
              "brightness"
              "battery"
              "caffeine"
              "date"
              "tray"
            ];
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            start = [
              "workspaces"
              "media"
            ];
            widget_spacing = 8;
          };
        };
        control_center.sidebar = "full";
        location.address = "Essen, Germany";
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-clock"
            "lockscreen-date"
            "lockscreen-media"
            "lockscreen-login-box"
          ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
            "lockscreen-clock" = {
              type = "clock";
              cx = 902.5;
              cy = 215.5;
              box_height = 128.0;
              box_width = 384.0;
              settings = {
                background = false;
                shadow = false;
              };
            };
            "lockscreen-date" = {
              type = "clock";
              cx = 902.5;
              cy = 311.5;
              box_height = 64.0;
              box_width = 384.0;
              settings = {
                background = false;
                format = "{:%d. %B %Y}";
                shadow = false;
              };
            };
            "lockscreen-media" = {
              type = "media_player";
              cx = 902.5;
              cy = 497.5;
              box_height = 196.0;
              box_width = 384.0;
            };
            "lockscreen-login-box" = {
              type = "login_box";
              cx = 902.5;
              cy = 713.5;
            };
          };
        };
        nightlight.enabled = true;
        shell = {
          font_family = "Monocraft";
          launch_apps_as_systemd_services = true;
          niri_overview_type_to_launch_enabled = true;
          panel = {
            open_near_click_control_center = true;
            transparency_mode = "soft";
          };
          password_style = "random";
          polkit_agent = true;
          telemetry_enabled = false;
        };
        theme = {
          builtin = "Catppuccin";
          source = "builtin";
          templates = {
            enable_builtin_templates = false;
            enable_community_templates = false;
          };
        };
        widget = {
          battery.display_mode = "graphic";
          clock.format = "{:%H:%M:%S}";
          network.show_label = false;
          workspaces.labels_only_when_occupied = true;
        };
      };
    };
  };
}

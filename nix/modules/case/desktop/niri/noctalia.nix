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
        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
        };
        shell = {
          font_family = "Monocraft";
          niri_overview_type_to_launch_enabled = true;
          panel = {open_near_click_control_center = true;};
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
          workspaces = {
            capsule_radius = "auto";
            labels_only_when_occupied = true;
          };
        };
      };
    };
  };
}

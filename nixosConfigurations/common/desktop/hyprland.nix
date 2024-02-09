{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) flatten getExe mapAttrsToList;

  mkDirectionKeys = key: direction: [
    "$mod, ${key}, movefocus, ${direction}"
    "$mod SHIFT, ${key}, movewindoworgroup, ${direction}"
    "$mod CTRL, ${key}, movecurrentworkspacetomonitor, ${direction}"
  ];

  mkWorkspaceKeys = key: workspace: [
    "$mod, ${key}, workspace, ${workspace}"
    "$mod SHIFT, ${key}, movetoworkspacesilent, ${workspace}"
  ];

  mkWorkspaceKeys' = workspace: mkWorkspaceKeys workspace workspace;

  wallpaper = pkgs.fetchurl {
    name = "sway-wallpaper.jpg";
    url = "https://scrumplex.rocks/img/richard-horvath-catppuccin.jpg";
    hash = "sha256-HQ+ZvNPUCnYkAl21JR6o83OBsAJAvpBt93OUSm0ibLU=";
  };

  programs = {
    brightnessctl = getExe pkgs.brightnessctl;
    mpc = getExe pkgs.mpc-cli;
    pamixer = getExe pkgs.pamixer;
    sed = getExe pkgs.gnused;
    swaybg = getExe pkgs.swaybg;
  };

  wobSock = "$XDG_RUNTIME_DIR/wob.sock";
in {
  nixpkgs.overlays = [
    inputs.hyprland.overlays.default
  ];

  primaryUser.extraGroups = ["video" "input"];

  programs.hyprland.enable = true;

  hm.home.sessionVariables = {
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    "NIXOS_OZONE_WL" = "1";
  };

  hm.wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "${programs.swaybg} --image ${wallpaper}"
      ];
      general = {
        border_size = 4;
        gaps_in = 0;
        gaps_out = 0;
        "col.inactive_border" = "0xff1e1e2e"; # base
        "col.active_border" = "0xff89b4fa"; # blue
      };
      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
      };
      windowrule = [
        "float,^popup_pulsemixer$"
        "pin,^popup_pulsemixer$"
        "size 800 600,^popup_pulsemixer$"
        "center 1,^popup_pulsemixer$"
        "rounding 8,^popup_pulsemixer$"

        "workspace 4,^evolution$"
        "workspace 5,^Signal$"
        "workspace 5,^cinny$"
        "workspace 5,^Element$"
        "workspace 5,^discord$"
        "workspace 5,^org.telegram.desktop$"

        "tile,^DDNet$"
        "fullscreen,^DDNet$"
      ];
      windowrulev2 = [
        "bordercolor 0xffa6e3a1,fullscreen:1" # green
      ];
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = true;
      };
      "$mod" = "SUPER";
      bind =
        [
          "$mod, W, fullscreen, 1"
          "$mod, Escape, killactive"
          "$mod, Space, focuswindow, floating"
          "$mod SHIFT, Space, togglefloating"
          "$mod, F, fullscreen, 0"
          ", XF86AudioStop, exec, ${programs.mpc} stop"
          ", XF86AudioPlay, exec, ${programs.mpc} toggle"
          ", XF86AudioPause, exec, ${programs.mpc} toggle"
          ", XF86AudioNext, exec, ${programs.mpc} next"
          ", XF86AudioPrev, exec, ${programs.mpc} prev"
          ", XF86AudioMute, exec, ${programs.pamixer} -t && ${programs.pamixer} --get-volume > ${wobSock}"
          ", XF86AudioRaiseVolume, exec, ${programs.pamixer} -ui 2 && ${programs.pamixer} --get-volume > ${wobSock}"
          ", XF86AudioLowerVolume, exec, ${programs.pamixer} -ud 2 && ${programs.pamixer} --get-volume > ${wobSock}"
          "SHIFT, XF86AudioRaiseVolume, exec, ${programs.mpc} vol +2 && ${programs.mpc} vol | ${programs.sed} 's|n/a|0%|g;s/[^0-9]*//g' > ${wobSock}"
          "SHIFT, XF86AudioLowerVolume, exec, ${programs.mpc} vol -2 && ${programs.mpc} vol | ${programs.sed} 's|n/a|0%|g;s/[^0-9]*//g' > ${wobSock}"
          ", XF86MonBrightnessDown, exec, ${programs.brightnessctl} set 5%- | ${programs.sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}"
          ", XF86MonBrightnessUp, exec, ${programs.brightnessctl} set 5%+ | ${programs.sed} -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > ${wobSock}"
        ]
        ++ (
          flatten (
            mapAttrsToList mkDirectionKeys {
              "Left" = "l";
              "Right" = "r";
              "Up" = "u";
              "Down" = "d";
            }
          )
        )
        ++ (
          flatten (map mkWorkspaceKeys' ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0"])
        );
      bindm = [
        "$mod,mouse:272,movewindow"
        "$mod,mouse:273,resizewindow"
      ];
    };
  };

  hm.programs.fish.interactiveShellInit = lib.mkOrder 2000 ''
    test -n "$XDG_SESSION_TYPE" -a "$XDG_SESSION_TYPE" = "tty" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq 1; and begin
        Hyprland
    end
  '';
}

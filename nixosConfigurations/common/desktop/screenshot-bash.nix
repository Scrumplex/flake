{
  config,
  lib,
  pkgs,
  ...
}: let
  screenshot-bash = lib.getExe pkgs.screenshot-bash;

  pwgen = "${pkgs.pwgen}/bin/pwgen";
  swaymsg = "${config.hm.wayland.windowManager.sway.package}/bin/swaymsg";
  jq = "${pkgs.jq}/bin/jq";
  slurp = "${pkgs.slurp}/bin/slurp -b '#00000080' -c '#ffffffff' -B '#00000040'";
  grim = "${pkgs.grim}/bin/grim";
in {
  age.secrets."screenshot-bash" = {
    file = ../../../secrets/common/screenshot-bash.age;
    owner = "scrumplex";
    inherit (config.users.users.scrumplex) group;
  };
  hm = {
    xdg.configFile."screenshot-bash.conf".text = ''
      #!/usr/bin/env bash
      TARGET_FILENAME="${config.hm.home.homeDirectory}/Pictures/Screenshots/$(date +%s)_$(${pwgen} 6).png"

      TARGET_HOST="https://scrumplex.rocks"
      BASIC_AUTH="$(cat ${config.age.secrets."screenshot-bash".path})"

      do_screenshot() {
          area=$(${swaymsg} -t get_tree | ${jq} -r '.. | select(.pid? and .visible?) | "\(.rect.x),\(.rect.y - .deco_rect.height) \(.rect.width)x\(.rect.height + .deco_rect.height)"' | ${slurp})
          ${grim} -g "$area" "$1"
      }

      if [ $# -gt 0 ]; then
          if [ "$1" == "active_window" ]; then
              do_screenshot() {
                  area=$(${swaymsg} -t get_tree | ${jq} -j '.. | select(.type? and .focused) | "\(.rect.x),\(.rect.y - .deco_rect.height) \(.rect.width)x\(.rect.height + .deco_rect.height)"')
                  ${grim} -g "$area" "$1"
              }
          elif [ "$1" == "active_output" ]; then
              do_screenshot() {
                  output=$(${swaymsg} -t get_outputs | ${jq} -j '.. | select(.focused?) | .name')
                  ${grim} -o "$output" "$1"
              }
          fi
      fi
    '';

    wayland.windowManager.sway.config.keybindings = {
      "Print" = "exec ${screenshot-bash}";
      "Shift+Print" = "exec ${screenshot-bash} active_window";
      "${config.hm.wayland.windowManager.sway.config.modifier}+Print" = "exec ${screenshot-bash} active_output";
    };
  };

  environment.systemPackages = [pkgs.screenshot-bash];
}

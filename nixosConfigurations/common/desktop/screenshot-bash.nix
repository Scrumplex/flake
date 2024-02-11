{
  config,
  pkgs,
  ...
}: {
  hm = {
    xdg.configFile."screenshot-bash.conf".text = let
      pass = "${config.hm.programs.password-store.package}/bin/pass";
      pwgen = "${pkgs.pwgen}/bin/pwgen";
      hyprctl = "${config.hm.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl";
      jq = "${pkgs.jq}/bin/jq";
      slurp = "${pkgs.slurp}/bin/slurp -b '#00000080' -c '#ffffffff' -B '#00000040'";
      grim = "${pkgs.grim}/bin/grim";
    in ''
      #!/usr/bin/env bash
      TARGET_FILENAME="${config.hm.home.homeDirectory}/Pictures/Screenshots/$(date +%s)_$(${pwgen} 6).png"

      # The url to the endpoint
      TARGET_HOST="https://scrumplex.rocks"

      # The password defined in the endpointd
      PASSWORD="$(${pass} show "servers/x" | head -n 1)"

      # change screenshot tool depending on parameter
      do_screenshot() {
          active_workspaces=$(${hyprctl} -j monitors | ${jq} -r 'map(.activeWorkspace.id) | join(",")')
          area=$(${hyprctl} -j clients | ${jq} --arg active_workspaces "$active_workspaces" -r '.[] | select(.workspace.id | tostring | inside($active_workspaces)) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"' | ${slurp})
          ${grim} -g "$area" "$1"
      }

      if [ $# -gt 0 ]; then
          if [ "$1" == "active_window" ]; then
              do_screenshot() {
                  area=$(${hyprctl} -j activewindow | ${jq} -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
                  ${grim} -g "$area" "$1"
              }
          elif [ "$1" == "active_output" ]; then
              do_screenshot() {
                  output=$(${hyprctl} -j monitors | ${jq} -r "first(.[] | select(.focused)).name")
                  ${grim} -o "$output" "$1"
              }
          fi
      fi
    '';
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "noanim, ^selection$"
      ];
      bind = let
        screenshot-bash = "${pkgs.screenshot-bash}/bin/screenshot-bash";
      in [
        ",Print,exec,${screenshot-bash}"
        "SHIFT,Print,exec,${screenshot-bash} active_window"
        "$mod,Print,exec,${screenshot-bash} active_output"
      ];
    };
  };

  environment.systemPackages = with pkgs; [screenshot-bash];
}

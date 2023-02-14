{ config, pkgs, ... }:

{
  xdg.configFile."screenshot-bash.conf".text = let
    pass = "${pkgs.pass}/bin/pass";
    pwgen = "${pkgs.pwgen}/bin/pwgen";
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    jq = "${pkgs.jq}/bin/jq";
    slurp = "${pkgs.slurp}/bin/slurp";
    grim = "${pkgs.grim}/bin/grim";
  in ''
    #!/usr/bin/env bash
    TARGET_FILENAME="${config.home.homeDirectory}/Pictures/Screenshots/$(date +%s)_$(${pwgen} 6).png"

    # The url to the endpoint
    TARGET_HOST="https://scrumplex.rocks"

    # The password defined in the endpointd
    PASSWORD="$(${pass} show "servers/x" | head -n 1)"

    # change screenshot tool depending on parameter
    do_screenshot() {
        area=$(${swaymsg} -t get_tree | ${jq} -r '.. | select(.pid? and .visible?) | "\(.rect.x),\(.rect.y-."deco_rect".height) \(.rect.width)x\(.rect.height+."deco_rect".height)"' | ${slurp})
        ${grim} -g "$area" "$1"
    }

    if [ $# -gt 0 ]; then
        if [ "$1" == "active_window" ]; then
            do_screenshot() {
                area=$(${swaymsg} -t get_tree | ${jq} -j '.. | select(.type?) | select(.focused) | "\(.rect.x),\(.rect.y-."deco_rect".height) \(.rect.width)x\(.rect.height+."deco_rect".height)"')
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
  wayland.windowManager.sway.config.keybindings = let
    swayConf = config.wayland.windowManager.sway.config;
    mod = swayConf.modifier;
    screenshot-bash = "${pkgs.screenshot-bash}/bin/screenshot-bash";
  in {
    "Print" = "exec ${screenshot-bash}";
    "Shift+Print" = "exec ${screenshot-bash} active_window";
    "${mod}+Print" = "exec ${screenshot-bash} active_output";
  };

  home.packages = with pkgs; [ screenshot-bash ];
}

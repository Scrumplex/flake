{pkgs, ...}: {
  hm.services.wob = {
    enable = true;
    settings."" = {
      border_offset = 0;
      border_size = 2;
      bar_padding = 8;
      # TODO: get these from somewhere else
      border_color = "89dcebff";
      background_color = "11111be6";
      bar_color = "89dcebff";
    };
  };
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "wob-brightness";

      runtimeInputs = with pkgs; [brightnessctl];

      text = ''
        case "$1" in
          increase-brightness)
            brightnessctl set 5%+
            ;;
          decrease-brightness)
            brightnessctl set 5%-
            ;;
        esac


        systemctl --user is-active wob.socket || exit 0
        wob_socket=$(systemctl --user show --value --property Listen wob.socket | cut -d" " -f1)

        brightness=$((100*$(brightnessctl get)/$(brightnessctl max)))
        echo "$brightness" | tee "$wob_socket"
      '';
    })
    (pkgs.writeShellApplication {
      name = "wob-volume";

      runtimeInputs = with pkgs; [pamixer];

      text = ''
        case "$1" in
          toggle-mute)
            pamixer --toggle-mute
            ;;
          increase-volume)
            pamixer --unmute --increase 2
            ;;
          decrease-volume)
            pamixer --unmute --decrease 2
            ;;
        esac

        systemctl --user is-active wob.socket || exit 0
        wob_socket=$(systemctl --user show --value --property Listen wob.socket | cut -d" " -f1)

        muted=$(pamixer --get-mute)
        volume=$(pamixer --get-volume)

        if [ "$muted" == "true" ]; then
          echo "0" | tee "$wob_socket"
        else
          echo "$volume" | tee "$wob_socket"
        fi
      '';
    })
    (pkgs.writeShellApplication {
      name = "wob-mpc-volume";

      runtimeInputs = with pkgs; [mpc];

      text = ''
        case "$1" in
          increase-volume)
            mpc volume +2
            ;;
          decrease-volume)
            mpc volume -2
            ;;
        esac

        systemctl --user is-active wob.socket || exit 0
        wob_socket=$(systemctl --user show --value --property Listen wob.socket | cut -d" " -f1)

        volume=$(mpc volume | grep -oE '[0-9]+')
        echo "$volume" | tee "$wob_socket"
      '';
    })
  ];
}

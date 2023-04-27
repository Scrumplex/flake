{
  pkgs,
  device,
}: let
  v4l2-ctl = "${pkgs.v4l-utils}/bin/v4l2-ctl";
  jq = "${pkgs.jq}/bin/jq";
  sed = "${pkgs.gnused}/bin/sed";
  inotifywait = "${pkgs.inotify-tools}/bin/inotifywait";
  commonCode = pkgs.writeShellScript "camera-blank-common.sh" ''
    v4l_value() {
      ${v4l2-ctl} --device "${device}" -C "$1" | ${sed} 's|n/a|0|g;s/[^0-9]*//g'
    }

    is_blank() {
      auto_exposure=$(v4l_value auto_exposure)
      exposure_time_absolute=$(v4l_value exposure_time_absolute)
      [ "$auto_exposure" != "3" ] && [ "$exposure_time_absolute" == 3 ]
    }
  '';
in {
  exec = pkgs.writeShellScript "camera-blank.sh" ''
    # Based on https://git.sr.ht/~whynothugo/dotfiles/tree/adf6af990b0348974b657ed4241d4bcf83dbcea3/item/home/.local/lib/waybar-mic
    # Copyright (c) 2012-2021, Hugo Osvaldo Barrera <hugo@barrera.io>
    # Copyright (c) 2021,2023, Sefa Eyeoglu <contact@scrumplex.net>
    #
    # Permission to use, copy, modify, and/or distribute this software for any
    # purpose with or without fee is hereby granted, provided that the above
    # copyright notice and this permission notice appear in all copies.
    #
    # THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
    # REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
    # FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
    # INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    # LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    # OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    # PERFORMANCE OF THIS SOFTWARE.
    source ${commonCode}

    show() {
      if is_blank; then
        CLASS="blank"
        TEXT="󱜷"
      else
        CLASS="not-blank"
        TEXT="󰖠"
      fi

      ${jq} --compact-output \
        --null-input \
        --arg text "$TEXT" \
        --arg class "$CLASS" \
        '{"text": $text, "class": $class}'
    }

    monitor() {
      while true; do
        show
        ${inotifywait} --event open --event close --timeout 1 "${device}" &> /dev/null
      done
      exit
    }

    monitor
  '';
  return-type = "json";
  on-click = pkgs.writeShellScript "camera-blank-toggle.sh" ''
    # Copyright (c) 2021,2023, Sefa Eyeoglu <contact@scrumplex.net>
    #
    # Permission to use, copy, modify, and/or distribute this software for any
    # purpose with or without fee is hereby granted, provided that the above
    # copyright notice and this permission notice appear in all copies.
    #
    # THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
    # REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
    # FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
    # INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    # LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    # OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    # PERFORMANCE OF THIS SOFTWARE.

    source ${commonCode}

    if is_blank; then
      ${v4l2-ctl} --device "${device}" -c auto_exposure=3
    else
      ${v4l2-ctl} --device "${device}" -c auto_exposure=1 -c exposure_time_absolute=3
    fi
  '';
}

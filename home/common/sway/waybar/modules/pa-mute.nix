pkgs: let
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  jq = "${pkgs.jq}/bin/jq";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  grep = "${pkgs.gnugrep}/bin/grep";
in {
  exec = pkgs.writeShellScript "pa-mute.sh" ''
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


    show() {
      muted=$(${pamixer} --default-source --get-mute 2> /dev/null)
      if [ "$muted" == "true" ]; then
        CLASS="muted"
        TEXT="󰍭"
      else
        CLASS="not-muted"
        TEXT="󰍬"
      fi

      ${jq} --compact-output \
        --null-input \
        --arg text "$TEXT" \
        --arg class "$CLASS" \
        '{"text": $text, "class": $class}'
    }

    monitor() {
      show

      ${pactl} subscribe | ${grep} --line-buffered "'change' on source" |
        while read -r _; do
          show
        done
      exit
    }

    monitor
  '';
  return-type = "json";
  on-click = "${pamixer} --default-source --toggle-mute";
}

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
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) getBin;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.strings) escapeShellArg optionalString;

  getExe' = x: y: "${getBin x}/bin/${y}";

  cfg = config.programs.waybar.extraModules.paMute;
  restoreAlsaState = cfg.alsaState.card != null && cfg.alsaState.file != null;
in {
  options.programs.waybar.extraModules.paMute = {
    enable = mkEnableOption "pa-mute waybar module";

    alsaState = {
      card = mkOption {
        default = null;
        description = "Number of ALSA card. Disabled if null";
        type = lib.types.nullOr lib.types.str;
      };

      file = mkOption {
        default = null;
        description = "Path to ALSA state file to restore when toggling. Disabled if null";
        type = lib.types.nullOr lib.types.path;
      };
    };

    muted = {
      label = mkOption {
        default = "muted";
        description = "Label shown when source is muted";
        type = lib.types.str;
      };
    };

    unmuted = {
      label = mkOption {
        default = "unmuted";
        description = "Label shown when source is unmuted";
        type = lib.types.str;
      };
    };

    moduleName = mkOption {
      default = "pa-mute";
      description = "Name of waybar module";
      type = lib.types.str;
    };

    onClickScript = mkOption {
      description = "Script when clicking module";
      internal = true;
      type = lib.types.path;
    };

    execScript = mkOption {
      description = "Script that updates module label";
      internal = true;
      type = lib.types.path;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        # both must be either null or have a value
        assertion = (cfg.alsaState.card == null) == (cfg.alsaState.file == null);
        message = "pa-mute: alsaState values must both be non-null or both be null";
      }
    ];
    programs.waybar = {
      extraModules.paMute = {
        onClickScript = let
          pamixer = getExe pkgs.pamixer;
          alsactl = getExe' pkgs.alsa-utils "alsactl";
        in
          pkgs.writeShellScript "pa-mute-toggle.sh" ''
            ${pamixer} --default-source --toggle-mute
            ${optionalString restoreAlsaState ''
              muted=$(${pamixer} --default-source --get-mute)
              [ "$muted" == "false" ] \
                && ${alsactl} restore -f ${escapeShellArg cfg.alsaState.file} ${escapeShellArg cfg.alsaState.card}
            ''}
          '';

        execScript = let
          pamixer = getExe pkgs.pamixer;
          jq = getExe pkgs.jq;
          pactl = getExe' pkgs.pulseaudio "pactl";
          grep = getExe pkgs.gnugrep;
        in
          pkgs.writeShellScript "pa-mute.sh" ''
            show() {
              muted=$(${pamixer} --default-source --get-mute 2> /dev/null)
              if [ "$muted" == "true" ]; then
                CLASS="muted"
                TEXT=${escapeShellArg cfg.muted.label}
              else
                CLASS="not-muted"
                TEXT=${escapeShellArg cfg.unmuted.label}
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
      };

      settings.mainBar."custom/${cfg.moduleName}" = {
        exec = cfg.execScript;
        on-click = cfg.onClickScript;
        return-type = "json";
      };
    };
  };
}

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
  inherit (lib) mdDoc;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatLines concatStringsSep;
  inherit (lib.trivial) pipe;

  cfg = config.programs.waybar.extraModules.cameraBlank;

  propToCondition = prop: value: ''
    [ "$(v4l_value ${prop})" != "${value}" ] && return 1
  '';
  propToParameter = prop: value: "-c ${prop}=${value}";

  v4l2-ctl = "${pkgs.v4l-utils}/bin/v4l2-ctl";
  jq = "${pkgs.jq}/bin/jq";
  sed = "${pkgs.gnused}/bin/sed";
  commonCode = pkgs.writeShellScript "camera-blank-common.sh" ''
    v4l_value() {
      ${v4l2-ctl} --device "${cfg.device}" -C "$1" | ${sed} 's|n/a|0|g;s/[^0-9]*//g'
    }

    is_blank() {
      ${pipe cfg.blanked.props [(mapAttrsToList propToCondition) concatLines]}
      return 0
    }
  '';
in {
  options.programs.waybar.extraModules.cameraBlank = {
    enable = mkEnableOption "camera-blank waybar module";

    device = mkOption {
      description = ''
        Path to the V4L2 device that should be blanked by this module.
      '';
      example = "/dev/v4l/by-id/usb-046d_Logitech_Webcam_C925e_D8A39E5F-video-index0";
      type = lib.types.str;
    };

    toggleStateFile = mkOption {
      default = "$XDG_RUNTIME_DIR/camera-blank.state";
      description = ''
        Path to FIFO to update module when camera state changes.
      '';
      type = lib.types.str;
    };

    blanked = {
      label = mkOption {
        default = "blank";
        description = "Label shown when blanking camera";
        type = lib.types.str;
      };
      props = mkOption {
        description = mdDoc ''
          Properties to set when blanking the camera.
          You can query all available options using `v4l2-ctl -d <path to device> -l`.
        '';
        example = {
          auto_exposure = "1";
          exposure_time_absolute = "3";
        };
        type = lib.types.attrs;
      };
    };

    unblanked = {
      label = mkOption {
        default = "not blank";
        description = "Label shown when unblanking camera";
        type = lib.types.str;
      };
      props = mkOption {
        description = mdDoc ''
          Properties to set when unblanking the camera.
          You can query all available options using `v4l2-ctl -d <path to device> -l`.
        '';
        example = {
          auto_exposure = "3";
        };
        type = lib.types.attrs;
      };
    };

    moduleName = mkOption {
      default = "camera-blank";
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
    programs.waybar = {
      extraModules.cameraBlank = {
        onClickScript = pkgs.writeShellScript "camera-blank-toggle.sh" ''
          source ${commonCode}

          if is_blank; then
            ${v4l2-ctl} --device "${cfg.device}" ${pipe cfg.unblanked.props [(mapAttrsToList propToParameter) (concatStringsSep " ")]}

          else
            ${v4l2-ctl} --device "${cfg.device}" ${pipe cfg.blanked.props [(mapAttrsToList propToParameter) (concatStringsSep " ")]}
          fi

          echo "" >> "${cfg.toggleStateFile}"
        '';

        execScript = pkgs.writeShellScript "camera-blank.sh" ''
          source ${commonCode}

          show() {
            if is_blank; then
              CLASS="blank"
              TEXT="${cfg.blanked.label}"
            else
              CLASS="not-blank"
              TEXT="${cfg.unblanked.label}"
            fi

            ${jq} --compact-output \
              --null-input \
              --arg text "$TEXT" \
              --arg class "$CLASS" \
              '{"text": $text, "class": $class}'
          }

          monitor() {
            tail -f "${cfg.toggleStateFile}" | while true; do
              show
              read -st5
            done
            exit
          }

          truncate -s0 "${cfg.toggleStateFile}"
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

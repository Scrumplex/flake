{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles.pipewire;
in {
  options.roles.pipewire = {
    enable = mkEnableOption "pipewire role";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    roles.base.user.extraGroups = ["rtkit"];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hm.services.pipewire = {
      enable = true;
      instances = {
        compressor = {
          config = ./compressor.conf;
          extraPackages = [pkgs.calf];
        };
        desktop-source = {config = ./desktop-source.conf;};
        #equalizer = {
        #  config = ./equalizer.conf;
        #  extraPackages = [ pkgs.lsp-plugins ];
        #};
      };
    };

    environment.etc."wireplumber/main.lua.d/51-schiit.lua".text = ''
      rule = {
        matches = {
          {
            { "node.name", "equals", "alsa_output.usb-Schiit_Audio_Schiit_Modi_3_-00.analog-stereo" },
          },
        },
        apply_properties = {
          ["audio.format"] = "S32_LE",
          ["audio.rate"] = 96000,
          ["api.alsa.period-size"] = 128,
        },
      }
      table.insert(alsa_monitor.rules,rule)
    '';
  };
}

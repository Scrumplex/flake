{pkgs, ...}: {
  security.rtkit.enable = true;
  primaryUser.extraGroups = ["rtkit"];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.configPackages = [
      (pkgs.writeTextFile {
        name = "schiit-wireplumber-rules";
        text = ''
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
        destination = "/share/wireplumber/main.lua.d/51-schiit.lua";
      })
    ];
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
}

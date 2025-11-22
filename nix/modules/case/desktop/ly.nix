{lib, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    services.displayManager.ly = {
      enable = true;
      x11Support = false;
      settings = {
        animation = "colormix";
        battery_id = "BAT1";
        brightness_down_cmd = "${lib.getExe pkgs.brightnessctl} -q -n s 10%-";
        brightness_up_cmd = "${lib.getExe pkgs.brightnessctl} -q -n s 10%+";
        default_input = "password";
        setup_cmd =
          (pkgs.writeScript "fake-wrapper" ''
            exec "$@"
          '').outPath;
      };
    };
  };
}

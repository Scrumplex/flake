{
  flake.modules.nixos.vr = {
    services.monado = {
      enable = true;
      defaultRuntime = true;
    };

    systemd.user.services."monado".environment = {
      STEAMVR_LH_ENABLE = "true";
      XRT_COMPOSITOR_COMPUTE = "1";
    };
  };

  flake.modules.homeManager.vr = {osConfig, ...}: {
    xdg.configFile."openxr/1/active_runtime.json".source = osConfig.environment.etc."xdg/openxr/1/active_runtime.json".source;
  };
}

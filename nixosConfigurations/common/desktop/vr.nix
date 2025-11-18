{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.profile.vr;
in {
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  options.profile.vr.enableHighPrioKernelPatch = mkEnableOption "kernel patch to allow high priority graphics for all clients";

  config = {
    profile.amdgpu.patches = mkIf cfg.enableHighPrioKernelPatch [
      inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch
    ];

    services.monado = {
      enable = true;
      defaultRuntime = true;
    };

    services.wivrn = {
      enable = false;
      openFirewall = true;
    };

    systemd.user.services."monado".environment = {
      STEAMVR_LH_ENABLE = "true";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    environment.systemPackages = with pkgs; [
      bs-manager
      index_camera_passthrough
      wayvr-dashboard
      wlx-overlay-s
    ];

    hm.xdg.configFile."openvr/openvrpaths.vrpath".text = ''
      {
        "config" :
        [
          "${config.hm.xdg.dataHome}/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "${config.hm.xdg.dataHome}/Steam/logs"
        ],
        "runtime" :
        [
          "${pkgs.opencomposite-vendored}/lib/opencomposite",
          "${config.hm.xdg.dataHome}/Steam/steamapps/common/SteamVR"
        ],
        "version" : 1
      }
    '';
    hm.xdg.configFile."openxr/1/active_runtime.json".source = config.environment.etc."xdg/openxr/1/active_runtime.json".source;
  };
}

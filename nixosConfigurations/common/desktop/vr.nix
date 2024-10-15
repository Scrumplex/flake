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
  options.profile.vr.enableHighPrioKernelPatch = mkEnableOption "kernel patch to allow high priority graphics for all clients";

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  config = {
    profile.amdgpu.patches = mkIf cfg.enableHighPrioKernelPatch [
      inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch
    ];

    services.monado = {
      enable = true;
      defaultRuntime = true;
    };

    systemd.user.services."monado".environment = {
      STEAMVR_LH_ENABLE = "true";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    environment.systemPackages = with pkgs; [
      index_camera_passthrough
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

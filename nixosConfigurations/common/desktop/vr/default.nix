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

  amdgpu-kernel-module = pkgs.callPackage ./amdgpu.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  options.profile.vr.enableHighPrioKernelPatch = mkEnableOption "kernel patch to allow high priority graphics for all clients";

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  config = {
    nixpkgs.xr.enableUnstripped = true;

    boot.extraModulePackages = mkIf cfg.enableHighPrioKernelPatch [
      (amdgpu-kernel-module.overrideAttrs (prev: {
        patches = (prev.patches or []) ++ [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch];
      }))
    ];

    services.monado = {
      enable = true;
      defaultRuntime = true;
    };

    environment.systemPackages = with pkgs; [
      index_camera_passthrough
      opencomposite-helper
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
          "${pkgs.opencomposite}/lib/opencomposite",
          "${config.hm.xdg.dataHome}/Steam/steamapps/common/SteamVR"
        ],
        "version" : 1
      }
    '';
  };
}

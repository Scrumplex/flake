{config, ...}: {
  primaryUser.extraGroups = ["video"];

  boot.extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  boot.kernelModules = ["v4l2loopback"];
}
